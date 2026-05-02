import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Fetches the most recent transactions for the current user.
class GetRecentTransactions {
  const GetRecentTransactions(this._repository);

  final TransactionRepository _repository;

  Future<List<Transaction>> call({int limit = 3}) =>
      _repository.getRecentTransactions(limit: limit);
}
