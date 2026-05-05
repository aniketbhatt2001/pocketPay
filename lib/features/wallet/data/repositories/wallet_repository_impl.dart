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
  Future<Result<Wallet>> getWalletBalance() async {
    try {
      final wallet = await _datasource.getWalletBalance();

      return Result.success(wallet);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

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
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> addMoney({required double amount}) async {
    try {
      await _datasource.addMoney(amount: amount);
      return Result.success(null);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
