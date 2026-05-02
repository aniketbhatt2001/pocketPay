part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

/// Initial state — nothing loaded yet.
final class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Wallet balance is being fetched.
final class HomeWalletLoading extends HomeState {
  const HomeWalletLoading();
}

/// Wallet and recent transactions loaded successfully.
final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.wallet, required this.recentTransactions});

  final Wallet wallet;
  final List<Transaction> recentTransactions;
}

/// An error occurred while loading.
final class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
}
