import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/services/razorpay_service.dart';
import '../../../../features/wallet/domain/usecases/add_money.dart';

part 'add_money_state.dart';

/// Manages the "Add Money" flow:
///   1. User enters an amount.
///   2. [RazorpayService.openCheckout] opens the payment UI.
///   3. On payment success → [AddMoneyUseCase] updates the Supabase wallet.
///   4. Emits [AddMoneySuccess] so the caller can refresh the balance.
///

class AddMoneyCubit extends Cubit<AddMoneyState> {
  AddMoneyCubit({
    required AddMoneyUseCase addMoney,
    required String razorpayKeyId,
  }) : _addMoney = addMoney,
       super(const AddMoneyIdle()) {
    _razorpay = RazorpayService(
      keyId: razorpayKeyId,
      onSuccess: _onPaymentSuccess,
      onError: _onPaymentError,
      onExternalWallet: _onExternalWallet,
    );
  }

  final AddMoneyUseCase _addMoney;
  late final RazorpayService _razorpay;

  /// Amount held while the checkout is open.
  double _pendingAmount = 0;

  /// Opens the Razorpay checkout for [amount] (INR).
  void initiatePayment({required double amount, required String userPhone}) {
    try {
      if (amount <= 0) {
        emit(const AddMoneyFailure('Please enter a valid amount.'));
        return;
      }

      _pendingAmount = amount;
      emit(const AddMoneyProcessing());
      _razorpay.openCheckout(
        RazorpayOptions(amount: amount, contact: userPhone),
      );
    } catch (e) {
      log('[AddMoneyCubit] openCheckout error: $e');
      emit(AddMoneyFailure(e.toString()));
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    log('[AddMoneyCubit] payment success: ${response.paymentId}');

    try {
      emit(const AddMoneyUpdatingWallet());
      await _addMoney(amount: _pendingAmount);
      emit(AddMoneySuccess(amount: _pendingAmount));
    } catch (e) {
      log('[AddMoneyCubit] wallet update failed: $e');
      emit(AddMoneyFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    log('[AddMoneyCubit] payment error: ${response.message}');
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      emit(const AddMoneyIdle());
    } else {
      emit(
        AddMoneyFailure(
          response.message ?? 'Payment failed. Please try again.',
        ),
      );
    }
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    log('[AddMoneyCubit] external wallet: ${response.walletName}');
    emit(const AddMoneyIdle());
  }

  /// Resets to idle — call after showing an error to allow retry.
  void reset() => emit(const AddMoneyIdle());

  @override
  Future<void> close() {
    _razorpay.dispose();
    return super.close();
  }
}
