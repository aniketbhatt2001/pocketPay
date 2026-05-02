import '../entities/transaction.dart';

/// Contract for transaction data operations.
abstract class TransactionRepository {
  /// Fetches the most recent [limit] transactions for the current user.
  Future<List<Transaction>> getRecentTransactions({int limit = 3});

  /// Fetches all transactions for the current user.
  Future<List<Transaction>> getAllTransactions();
}
