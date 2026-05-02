import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/usecases/get_recent_transactions.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../../wallet/domain/usecases/get_wallet_balance.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetWalletBalanceUseCase getWalletBalance,
    required GetRecentTransactions getRecentTransactions,
  }) : _getWalletBalance = getWalletBalance,
       _getRecentTransactions = getRecentTransactions,
       super(const HomeInitial());

  final GetWalletBalanceUseCase _getWalletBalance;
  final GetRecentTransactions _getRecentTransactions;

  /// Loads wallet balance and recent transactions in parallel.
  Future<void> loadHome() async {
    try {
      emit(const HomeWalletLoading());

      final results = await Future.wait([
        _getWalletBalance(),
        //_getRecentTransactions(limit: 3),
      ]);

      emit(
        HomeLoaded(
          wallet: results[0] as Wallet,
          recentTransactions: [],
          //    recentTransactions: results[1] as List<Transaction>,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
