import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Fetches all transactions for the current user.
class GetAllTransactions {
  const GetAllTransactions(this._repository);

  final TransactionRepository _repository;

  Future<Result<List<Transaction>>> call() => _repository.getAllTransactions();
}
