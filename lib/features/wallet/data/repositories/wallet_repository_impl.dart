import 'package:pocket_pay_demo/core/error/exceptions.dart';
import 'package:pocket_pay_demo/core/error/failures.dart';
import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/wallet/domain/entities/transfer_reponse.dart';

import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._datasource);

  final WalletRemoteDatasource _datasource;

  @override
  Future<Wallet> getWalletBalance() => _datasource.getWalletBalance();

  @override
  Future<Result<TransferReponse>> sendMoney({
    required String recipientPhone,
    required double amount,
    required String senderUserId,
    String? note,
  }) async {
    try {
      final res = await _datasource.sendMoney(
        recipientPhone: recipientPhone,
        amount: amount,
        note: note,
        senderUserId: senderUserId,
      );
      return Result.success(res.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> addMoney({required double amount}) =>
      _datasource.addMoney(amount: amount);
}
