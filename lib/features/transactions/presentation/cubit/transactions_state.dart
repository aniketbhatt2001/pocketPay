part of 'transactions_cubit.dart';

sealed class TransactionsState {
  const TransactionsState();
}

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

final class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded(this.transactions);
  final List<Transaction> transactions;
}

final class TransactionsError extends TransactionsState {
  const TransactionsError(this.message);
  final String message;
}
