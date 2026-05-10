import 'package:drift/drift.dart';
import 'package:pocket_pay_demo/core/database/app_database.dart';
import 'package:pocket_pay_demo/features/wallet/data/models/wallet_model.dart';

/// Local datasource that reads/writes wallet data from the Drift SQLite cache.
class WalletLocalDatasource {
  WalletLocalDatasource(this._db);

  final AppDatabase _db;

  /// Returns the cached wallet, or null if the cache is empty.
  Future<WalletModel?> getCachedWallet() async {
    final row = await _db.getCachedWallet();
    if (row == null) return null;
    return WalletModel(
      id: row.id,
      userId: row.userId,
      balance: row.balance,
      currency: row.currency,
      updatedAt: row.updatedAt,
    );
  }

  /// Persists a wallet to the local cache.
  Future<void> cacheWallet(WalletModel wallet) async {
    await _db.upsertWallet(
      WalletsTableCompanion(
        id: Value(wallet.id),
        userId: Value(wallet.userId),
        balance: Value(wallet.balance),
        currency: Value(wallet.currency),
        updatedAt: Value(wallet.updatedAt),
      ),
    );
  }
}
