import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/wallet/domain/entities/transfer_reponse.dart';

import '../repositories/wallet_repository.dart';

/// Sends money from the current user's wallet to a recipient.
class SendMoneyUseCase {
  const SendMoneyUseCase(this._repository);

  final WalletRepository _repository;

  Future<Result<TransferReponse>> call({
    required String recipientPhone,
    required double amount,
    required String senderUserId,
    String? note,
  }) => _repository.sendMoney(
    recipientPhone: recipientPhone,
    senderUserId: senderUserId,
    amount: amount,
    note: note,
  );
}
