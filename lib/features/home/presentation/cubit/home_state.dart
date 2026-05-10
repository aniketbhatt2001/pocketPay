part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

/// Initial state — nothing loaded yet.
final class HomeInitial extends HomeState {
  const HomeInitial();
}

/// First load with no local cache — show skeleton.
final class HomeWalletLoading extends HomeState {
  const HomeWalletLoading();
}

/// Data is available (from cache or remote).
///
/// [isRefreshing] is true while a background remote fetch is in progress,
/// allowing the UI to show a subtle indicator without hiding the content.
final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.wallet,
    required this.recentTransactions,
    this.walletError,
    this.transactionError,
    this.isRefreshing = false,
  });

  final Wallet wallet;
  final List<Transaction> recentTransactions;
  final String? walletError;
  final String? transactionError;

  /// True while a background sync is running on top of cached data.
  final bool isRefreshing;

  HomeLoaded copyWith({
    Wallet? wallet,
    List<Transaction>? recentTransactions,
    String? walletError,
    String? transactionError,
    bool? isRefreshing,
  }) {
    return HomeLoaded(
      wallet: wallet ?? this.wallet,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      walletError: walletError ?? this.walletError,
      transactionError: transactionError ?? this.transactionError,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

/// An unrecoverable error with no cached data to fall back on.
final class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
}
