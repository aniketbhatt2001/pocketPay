import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

/// Fetches the current wallet balance for the authenticated user.
class GetWalletBalanceUseCase {
  const GetWalletBalanceUseCase(this._repository);

  final WalletRepository _repository;

  Future<Result<Wallet>> call() => _repository.getWalletBalance();
}
