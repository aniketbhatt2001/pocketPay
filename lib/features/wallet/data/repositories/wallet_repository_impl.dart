import 'package:pocket_pay_demo/core/error/failures.dart';
import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:pocket_pay_demo/features/wallet/domain/entities/transfer_reponse.dart';

import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._remote, this._local);

  final WalletRemoteDatasource _remote;
  final WalletLocalDatasource _local;

  /// Cache-first: returns cached wallet immediately, then fetches fresh data
  /// from Supabase and updates the cache. The caller always gets the latest
  /// available data — cached or fresh.
  @override
  Future<Result<Wallet>> getWalletBalance() async {
    try {
      // 1. Try to return cached data first for instant display.
      final cached = await _local.getCachedWallet();

      // 2. Always fetch fresh data from remote.
      try {
        final fresh = await _remote.getWalletBalance();
        await _local.cacheWallet(fresh);
        return Result.success(fresh);
      } catch (remoteError) {
        // Remote failed — fall back to cache if available.
        if (cached != null) {
          return Result.success(cached);
        }
        return Result.failure(mapExceptionToFailure(remoteError));
      }
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
      final res = await _remote.sendMoney(
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
      await _remote.addMoney(amount: amount);
      return Result.success(null);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
