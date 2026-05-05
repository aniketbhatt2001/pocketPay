import 'package:pocket_pay_demo/core/error/exceptions.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';
import 'package:pocket_pay_demo/features/transactions/data/models/transaction_model.dart';

class TransactionRemoteDataSource {
  final SupabaseService client;

  TransactionRemoteDataSource(this.client);

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final userId = client.currentUser?.id;
      if (userId == null) {
        throw (UnauthorizedException("Unauthorized access"));
      }
      final response = await client.invokeFn('list-transactions');

      final body = response.data;

      if (body['items'] == null) {
        throw InvalidResponseException("Missing items");
      }

      return (body['items'] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList();
    } catch (e, st) {
      print(st);
      throw mapFunctionExceptionToCustom(e);
    }
  }
}
