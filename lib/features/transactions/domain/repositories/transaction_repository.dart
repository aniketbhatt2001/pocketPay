import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/transaction.dart';

/// Contract for transaction data operations.
abstract class TransactionRepository {
  /// Fetches all transactions for the current user.
  Future<Result<List<Transaction>>> getAllTransactions();
}
