import '../entities/wallet.dart';

/// Contract for wallet data operations.
abstract class WalletRepository {
  /// Fetches the wallet for the currently authenticated user.
  Future<Wallet> getWalletBalance();

  /// Sends money to a recipient.
  Future<void> sendMoney({
    required String recipientPhone,
    required double amount,
    String? note,
  });

  /// Adds money to the wallet.
  Future<void> addMoney({required double amount});
}
