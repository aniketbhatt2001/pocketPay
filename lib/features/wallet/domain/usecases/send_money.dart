import '../repositories/wallet_repository.dart';

/// Sends money from the current user's wallet to a recipient.
class SendMoneyUseCase {
  const SendMoneyUseCase(this._repository);

  final WalletRepository _repository;

  Future<void> call({
    required String recipientPhone,
    required double amount,
    String? note,
  }) => _repository.sendMoney(
    recipientPhone: recipientPhone,
    amount: amount,
    note: note,
  );
}
