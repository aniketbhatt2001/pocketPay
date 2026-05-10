import 'package:drift/drift.dart';
import 'package:pocket_pay_demo/core/database/app_database.dart';
import 'package:pocket_pay_demo/features/transactions/data/models/transaction_model.dart';
import 'package:pocket_pay_demo/features/transactions/domain/entities/transaction.dart';

/// Local datasource that reads/writes transaction history from the Drift
/// SQLite database.
///
/// Schema mirrors public.transactions in Supabase:
///   - type   CHECK IN ('deposit','send','receive')
///   - status CHECK IN ('pending','completed','failed')
///   - amount CHECK > 0
///   - created_at / updated_at are nullable (timestamptz NULL DEFAULT now())
///
/// Uses upsert (INSERT OR REPLACE) so history accumulates — records are
/// never deleted when the server returns a partial response.
class TransactionLocalDatasource {
  TransactionLocalDatasource(this._db);

  final AppDatabase _db;

  /// Returns all locally stored transactions for [userId], newest first.
  Future<List<TransactionModel>> getTransactions(String userId) async {
    final rows = await _db.getCachedTransactions(userId);
    return rows.map(_rowToModel).toList();
  }

  /// Merges [transactions] into the local store.
  ///
  /// Existing rows (same PK) are updated; new rows are inserted.
  /// No rows are ever deleted — full history is preserved.
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final companions = transactions.map(_modelToCompanion).toList();
    await _db.upsertTransactions(companions);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  TransactionModel _rowToModel(TransactionsTableData row) {
    return TransactionModel(
      id: row.id,
      walletId: row.walletId,
      userId: row.userId,
      type: TransactionType.fromString(row.type),
      amount: row.amount,
      description: row.description,
      status: TransactionStatus.fromString(row.status),
      referenceId: row.referenceId,
      balanceBefore: row.balanceBefore,
      balanceAfter: row.balanceAfter,
      // Both nullable — matches Supabase timestamptz NULL
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TransactionsTableCompanion _modelToCompanion(TransactionModel t) {
    return TransactionsTableCompanion(
      id: Value(t.id),
      walletId: Value(t.walletId),
      userId: Value(t.userId),
      type: Value(t.type.value),
      amount: Value(t.amount),
      description: Value(t.description),
      status: Value(t.status.value),
      referenceId: Value(t.referenceId),
      balanceBefore: Value(t.balanceBefore),
      balanceAfter: Value(t.balanceAfter),
      // Nullable timestamps — pass null when the server omits them
      createdAt: Value(t.createdAt),
      updatedAt: Value(t.updatedAt),
    );
  }
}
