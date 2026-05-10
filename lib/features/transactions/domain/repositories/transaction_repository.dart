import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/transaction.dart';

/// Contract for transaction data operations.
abstract class TransactionRepository {
  /// Returns transactions from the **local database only** — instant, no network.
  ///
  /// Use this to render the UI immediately on app start or screen open.
  Future<Result<List<Transaction>>> getCachedTransactions();

  /// Fetches fresh transactions from the **remote** (Supabase), persists them
  /// to the local database via upsert, then returns the merged local snapshot.
  ///
  /// Call this after [getCachedTransactions] to sync in the background.
  Future<Result<List<Transaction>>> syncTransactions();
}
