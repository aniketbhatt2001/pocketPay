import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._datasource);

  final TransactionRemoteDatasource _datasource;

  @override
  Future<List<Transaction>> getRecentTransactions({int limit = 3}) =>
      _datasource.getRecentTransactions(limit: limit);

  @override
  Future<List<Transaction>> getAllTransactions() =>
      _datasource.getAllTransactions();
}
