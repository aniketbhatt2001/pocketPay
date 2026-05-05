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

  Future<void> loadHome() async {
    try {
      emit(const HomeWalletLoading());

      final results = await Future.wait([
        _getWalletBalance(),
        _getAllTransactions(),
      ]);

      final walletResult = results[0] as Result<Wallet>;
      final txResult = results[1] as Result<List<Transaction>>;

      Wallet? wallet;
      List<Transaction>? transactions;
      String? walletError;
      String? txError;

      walletResult.fold(
        onSuccess: (w) => wallet = w,
        onFailure: (f) => walletError = f.message,
      );

      txResult.fold(
        onSuccess: (t) => transactions = t,
        onFailure: (f) => txError = f.message,
      );

      emit(
        HomeLoaded(
          wallet: wallet ?? Wallet(),
          recentTransactions: transactions ?? [],
          walletError: walletError,
          transactionError: txError,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
