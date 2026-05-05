import 'package:pocket_pay_demo/core/error/failures.dart';
import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';
import 'package:pocket_pay_demo/features/transactions/data/models/transaction_model.dart';
import 'package:pocket_pay_demo/features/transactions/data/remote_datasource.dart/transaction_datasource.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource transactionRemoteDataSource;
  TransactionRepositoryImpl(this.transactionRemoteDataSource);

  @override
  Future<Result<List<Transaction>>> getAllTransactions() async {
    try {
      final items = await transactionRemoteDataSource.getTransactions();
      final transactions = items.map((e) => e.toEntity()).toList();

      return Result.success(transactions);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
