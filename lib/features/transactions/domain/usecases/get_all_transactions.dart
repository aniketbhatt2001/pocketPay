import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Fetches all transactions for the current user.
class GetAllTransactions {
  const GetAllTransactions(this._repository);

  final TransactionRepository _repository;

  Future<List<Transaction>> call() => _repository.getAllTransactions();
}
