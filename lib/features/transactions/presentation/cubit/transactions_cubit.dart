import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_all_transactions.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({required GetAllTransactions getAllTransactions})
    : _getAllTransactions = getAllTransactions,
      super(const TransactionsInitial());

  final GetAllTransactions _getAllTransactions;

  Future<void> loadTransactions() async {
    try {
      emit(const TransactionsLoading());
      final result = await _getAllTransactions();
      result.fold(
        onSuccess: (value) {
          emit(TransactionsLoaded(value));
        },
        onFailure: (failure) {
          emit(TransactionsError(failure.message));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(TransactionsError(e.toString()));
    }
  }
}
