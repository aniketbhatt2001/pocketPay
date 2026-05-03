part of 'send_money_cubit.dart';

sealed class SendMoneyState {
  const SendMoneyState();
}

final class SendMoneyInitial extends SendMoneyState {
  const SendMoneyInitial();
}

final class SendMoneyLoading extends SendMoneyState {
  const SendMoneyLoading();
}

final class SendMoneySuccess extends SendMoneyState {
  const SendMoneySuccess();
}

final class SendMoneyError extends SendMoneyState {
  const SendMoneyError(this.message);
  final String message;
}
