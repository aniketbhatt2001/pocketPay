import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ── Tables ─────────────────────────────────────────────────────────────────

/// Local mirror of public.wallets.
class WalletsTable extends Table {
  @override
  String get tableName => 'wallets';

  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  RealColumn get balance => real()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local cache for the authenticated user's profile.
///
/// Mirrors the fields returned by the `get-user` edge function so the app
/// can restore a full [AuthUser] without a network call on subsequent launches.
class CachedUsersTable extends Table {
  @override
  String get tableName => 'cached_users';

  TextColumn get id => text()(); // uuid — PK
  TextColumn get phoneNumber => text().named('phone_number')();
  TextColumn get firstName => text().nullable().named('first_name')();
  TextColumn get lastName => text().nullable().named('last_name')();
  TextColumn get email => text().nullable()();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false)).named('biometric_enabled')();
  BoolColumn get isMpinSet =>
      boolean().withDefault(const Constant(false)).named('is_mpin_set')();
  BoolColumn get isProfileComplete =>
      boolean()
          .withDefault(const Constant(false))
          .named('is_profile_complete')();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

///
/// Column types and constraints are kept in sync with the Supabase schema:
///
///   id           uuid PK
///   wallet_id    uuid NOT NULL  → FK wallets(id)
///   user_id      uuid NOT NULL  → FK users(id)
///   type         text NOT NULL  CHECK (type IN ('deposit','send','receive'))
///   amount       numeric(15,2)  CHECK (amount > 0)
///   description  text NULL
///   status       text NOT NULL  DEFAULT 'pending'
///                               CHECK (status IN ('pending','completed','failed'))
///   reference_id text NULL
///   balance_before numeric(15,2) NULL
///   balance_after  numeric(15,2) NULL
///   created_at   timestamptz NULL  DEFAULT now()
///   updated_at   timestamptz NULL  DEFAULT now()
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  // Primary key
  TextColumn get id => text()();

  // Foreign keys (stored as text / UUID strings in SQLite)
  TextColumn get walletId => text().named('wallet_id')();
  TextColumn get userId => text().named('user_id')();

  // type: CHECK (type IN ('deposit','send','receive'))
  TextColumn get type =>
      text().customConstraint(
        "NOT NULL CHECK (type IN ('deposit','send','receive'))",
      )();

  // amount: numeric(15,2) NOT NULL CHECK (amount > 0)
  // SQLite has no NUMERIC(p,s) — REAL gives us double precision locally.
  RealColumn get amount =>
      real().customConstraint('NOT NULL CHECK (amount > 0)')();

  TextColumn get description => text().nullable()();

  // status: DEFAULT 'pending' CHECK (status IN ('pending','completed','failed'))
  TextColumn get status =>
      text().customConstraint(
        "NOT NULL DEFAULT 'pending' "
        "CHECK (status IN ('pending','completed','failed'))",
      )();

  TextColumn get referenceId => text().nullable().named('reference_id')();

  RealColumn get balanceBefore => real().nullable().named('balance_before')();
  RealColumn get balanceAfter => real().nullable().named('balance_after')();

  // Nullable timestamps — Supabase schema declares both as nullable
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ───────────────────────────────────────────────────────────────

@DriftDatabase(tables: [WalletsTable, TransactionsTable, CachedUsersTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.drop(transactionsTable);
        await m.createTable(transactionsTable);
      }
      if (from < 3) {
        // v2 → v3: add the cached_users table for offline session restore.
        await m.createTable(cachedUsersTable);
      }
    },
  );

  // ── Cached user queries ─────────────────────────────────────────────────

  /// Returns the locally cached user profile, or null if never synced.
  Future<CachedUsersTableData?> getCachedUser(String userId) =>
      (select(cachedUsersTable)
        ..where((u) => u.id.equals(userId))).getSingleOrNull();

  /// Upserts the user profile into the local cache.
  Future<void> upsertUser(CachedUsersTableCompanion user) =>
      into(cachedUsersTable).insertOnConflictUpdate(user);

  // ── Wallet queries ──────────────────────────────────────────────────────

  /// Returns the first cached wallet row, or null if the cache is empty.
  Future<WalletsTableData?> getCachedWallet() =>
      (select(walletsTable)..limit(1)).getSingleOrNull();

  /// Upserts a wallet row (insert or replace on conflict).
  Future<void> upsertWallet(WalletsTableCompanion wallet) =>
      into(walletsTable).insertOnConflictUpdate(wallet);

  // ── Transaction queries ─────────────────────────────────────────────────

  /// Returns all cached transactions for [userId], newest first.
  Future<List<TransactionsTableData>> getCachedTransactions(String userId) =>
      (select(transactionsTable)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  /// Upserts a batch of transactions.
  ///
  /// Existing rows (same PK) are updated in place; new rows are inserted.
  /// History is never deleted.
  Future<void> upsertTransactions(List<TransactionsTableCompanion> rows) async {
    await batch((b) {
      for (final row in rows) {
        b.insert(transactionsTable, row, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

// ── Connection helper ───────────────────────────────────────────────────────

QueryExecutor _openConnection() => driftDatabase(name: 'pocket_pay_db');
