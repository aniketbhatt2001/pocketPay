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
      final transactions = await _getAllTransactions();
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      log(e.toString());
      emit(TransactionsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
