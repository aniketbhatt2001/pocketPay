import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/wallet/domain/entities/transfer_reponse.dart';

import '../entities/wallet.dart';

/// Contract for wallet data operations.
abstract class WalletRepository {
  /// Fetches the wallet for the currently authenticated user.
  Future<Wallet> getWalletBalance();

  /// Sends money to a recipient.
  Future<Result<TransferReponse>> sendMoney({
    required String recipientPhone,
    required String senderUserId,
    required double amount,
    String? note,
  });

  /// Adds money to the wallet.
  Future<void> addMoney({required double amount});
}
