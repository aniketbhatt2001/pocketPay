import '../repositories/wallet_repository.dart';

/// Adds money to the current user's wallet.
class AddMoneyUseCase {
  const AddMoneyUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call({required double amount}) =>
      _repository.addMoney(amount: amount);
}
