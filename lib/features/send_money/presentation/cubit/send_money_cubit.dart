import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../wallet/domain/usecases/send_money.dart';

part 'send_money_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  SendMoneyCubit({required SendMoneyUseCase sendMoney})
    : _sendMoney = sendMoney,
      super(const SendMoneyInitial());

  final SendMoneyUseCase _sendMoney;

  Future<void> send({
    required String recipientPhone,
    required String senderUserId,
    required double amount,
    String? note,
  }) async {
    try {
      emit(const SendMoneyLoading());
      final res = await _sendMoney(
        recipientPhone: recipientPhone,
        amount: amount,
        note: note,
        senderUserId: senderUserId,
      );
      res.fold(
        onSuccess: (value) {
          emit(const SendMoneySuccess());
        },
        onFailure: (failure) {
          emit(SendMoneyError(failure.message));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(SendMoneyError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(const SendMoneyInitial());
}
