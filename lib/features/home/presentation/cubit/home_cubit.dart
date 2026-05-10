import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/features/transactions/domain/usecases/get_all_transactions.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/get_wallet_balance.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../wallet/domain/entities/wallet.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetWalletBalanceUseCase getWalletBalance,
    required GetCachedTransactions getCachedTransactions,
    required SyncTransactions syncTransactions,
  }) : _getWalletBalance = getWalletBalance,
       _getCachedTransactions = getCachedTransactions,
       _syncTransactions = syncTransactions,
       super(const HomeInitial());

  final GetWalletBalanceUseCase _getWalletBalance;
  final GetCachedTransactions _getCachedTransactions;
  final SyncTransactions _syncTransactions;

  /// Two-phase load:
  ///
  /// **Phase 1 — instant render from local DB (zero network)**
  ///   • Read cached wallet and transactions from SQLite.
  ///   • If anything is cached, emit [HomeLoaded(isRefreshing: true)] so the
  ///     user sees real content immediately with a subtle sync indicator.
  ///   • If the cache is cold (first launch), emit [HomeWalletLoading] and
  ///     wait for Phase 2.
  ///
  /// **Phase 2 — background sync with Supabase (one network call each)**
  ///   • Fetch fresh wallet balance from remote, update local cache.
  ///   • Fetch fresh transactions from remote, upsert into local DB.
  ///   • Emit [HomeLoaded(isRefreshing: false)] with the merged result.
  ///   • On network failure, the cached data from Phase 1 is kept — the user
  ///     never sees an error if they already had data.
  Future<void> loadHome() async {
    try {
      // ── Phase 1: read local DB — no network ───────────────────────────
      final cachedWalletResult = await _getWalletBalance();
      final cachedTxResult = await _getCachedTransactions();

      Wallet? cachedWallet;
      List<Transaction>? cachedTx;

      cachedWalletResult.fold(
        onSuccess: (w) => cachedWallet = w,
        onFailure: (_) {},
      );
      cachedTxResult.fold(onSuccess: (t) => cachedTx = t, onFailure: (_) {});

      final hasCachedData =
          cachedWallet != null || (cachedTx?.isNotEmpty ?? false);

      if (hasCachedData) {
        // Render immediately with cached data; show sync indicator.
        emit(
          HomeLoaded(
            wallet: cachedWallet ?? const Wallet(),
            recentTransactions: cachedTx ?? [],
            isRefreshing: true,
          ),
        );
      } else {
        // Cold cache — show skeleton until remote responds.
        emit(const HomeWalletLoading());
      }

      // ── Phase 2: sync from Supabase — one network call each ───────────
      final freshWalletResult = await _getWalletBalance();
      final freshTxResult = await _syncTransactions();

      if (isClosed) return;

      Wallet? freshWallet;
      List<Transaction>? freshTx;
      String? walletError;
      String? txError;

      freshWalletResult.fold(
        onSuccess: (w) => freshWallet = w,
        onFailure: (f) => walletError = f.message,
      );
      freshTxResult.fold(
        onSuccess: (t) => freshTx = t,
        onFailure: (f) => txError = f.message,
      );

      // Prefer fresh data; fall back to cached if remote failed.
      final wallet = freshWallet ?? cachedWallet ?? const Wallet();
      final transactions = freshTx ?? cachedTx ?? [];

      emit(
        HomeLoaded(
          wallet: wallet,
          recentTransactions: transactions,
          walletError: walletError,
          transactionError: txError,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      log('HomeCubit.loadHome error: $e');
      if (!isClosed) emit(HomeError(e.toString()));
    }
  }
}
