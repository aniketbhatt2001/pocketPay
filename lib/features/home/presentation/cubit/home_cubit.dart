import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/transactions/domain/usecases/get_all_transactions.dart';

import '../../../transactions/domain/entities/transaction.dart';

import '../../../wallet/domain/entities/wallet.dart';
import '../../../wallet/domain/usecases/get_wallet_balance.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetWalletBalanceUseCase getWalletBalance,
    required GetAllTransactions getAllTransactions,
  }) : _getWalletBalance = getWalletBalance,
       _getAllTransactions = getAllTransactions,

       super(const HomeInitial());

  final GetWalletBalanceUseCase _getWalletBalance;
  final GetAllTransactions _getAllTransactions;

  /// Loads wallet balance and recent transactions in parallel.
  Future<void> loadHome() async {
    try {
      emit(const HomeWalletLoading());

      final results = await Future.wait([
        _getWalletBalance(),
        _getAllTransactions(),
      ]);
      final res = results[1] as Result<List<Transaction>>;
      res.fold(
        onSuccess: (value) {
          emit(
            HomeLoaded(
              wallet: results[0] as Wallet,
              recentTransactions: value,
              //    recentTransactions: results[1] as List<Transaction>,
            ),
          );
        },
        onFailure: (failure) {
          emit(HomeError(failure.message));
        },
      );
      // emit(
      //   HomeLoaded(
      //     wallet: results[0] as Wallet,
      //     recentTransactions: .,
      //     //    recentTransactions: results[1] as List<Transaction>,
      //   ),
      // );
    } catch (e) {
      log(e.toString());
      emit(HomeError(e.toString()));
    }
  }
}
