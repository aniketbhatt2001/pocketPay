part of 'add_money_cubit.dart';

sealed class AddMoneyState {
  const AddMoneyState();
}

/// Idle — waiting for user input.
final class AddMoneyIdle extends AddMoneyState {
  const AddMoneyIdle();
}

/// Razorpay checkout is open / payment is in progress.
final class AddMoneyProcessing extends AddMoneyState {
  const AddMoneyProcessing();
}

/// Razorpay payment succeeded; now updating Supabase wallet.
final class AddMoneyUpdatingWallet extends AddMoneyState {
  const AddMoneyUpdatingWallet();
}

/// Wallet updated successfully.
final class AddMoneySuccess extends AddMoneyState {
  const AddMoneySuccess({required this.amount});
  final double amount;
}

/// Something went wrong.
final class AddMoneyFailure extends AddMoneyState {
  const AddMoneyFailure(this.message);
  final String message;
}
