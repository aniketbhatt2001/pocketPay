import 'dart:developer';

import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Callback types used by [RazorpayService].
typedef OnPaymentSuccess = void Function(PaymentSuccessResponse response);
typedef OnPaymentError = void Function(PaymentFailureResponse response);
typedef OnExternalWallet = void Function(ExternalWalletResponse response);

/// A thin, reusable wrapper around the Razorpay SDK.

class RazorpayService {
  RazorpayService({
    required this.keyId,
    required OnPaymentSuccess onSuccess,
    required OnPaymentError onError,
    OnExternalWallet? onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      onExternalWallet ?? _defaultExternalWallet,
    );
  }

  /// The Razorpay API key (e.g. `rzp_test_…` or `rzp_live_…`).
  final String keyId;

  late final Razorpay _razorpay;

  /// Opens the Razorpay payment checkout with the given [options].
  void openCheckout(RazorpayOptions options) {
    try {
      _razorpay.open(options.toMap(keyId: keyId));
    } catch (e) {
      log('[RazorpayService] openCheckout error: $e');
      rethrow;
    }
  }

  /// Releases all Razorpay listeners. Call this in [State.dispose] or
  /// [Cubit.close] — whichever owns this service.
  void dispose() => _razorpay.clear();

  static void _defaultExternalWallet(ExternalWalletResponse r) {
    log('[RazorpayService] External wallet selected: ${r.walletName}');
  }
}

class RazorpayOptions {
  const RazorpayOptions({
    required this.amount,
    required this.contact,
    this.name = 'PocketPay',
    this.description = 'Wallet top-up',
    this.themeColor = '#000666',
    this.email,
    this.orderId,
  });

  /// Amount in major currency unit (rupees). Converted to paise on checkout.
  final double amount;

  /// Pre-filled phone number (E.164 or local format).
  final String contact;

  /// Merchant / app name shown in the checkout UI.
  final String name;

  /// Short description shown below the merchant name.
  final String description;

  /// Hex colour for the checkout header (default: PocketPay brand blue).
  final String themeColor;

  /// Optional pre-filled email.
  final String? email;

  /// Optional Razorpay order ID (for server-side order flow).
  final String? orderId;

  /// Serialises to the raw map that [Razorpay.open] expects.
  Map<String, dynamic> toMap({required String keyId}) {
    return {
      'key': keyId,
      'amount': (amount * 100).toInt(), // paise
      'name': name,
      'description': description,
      'prefill': {'contact': contact, if (email != null) 'email': email},
      'theme': {'color': themeColor},
      if (orderId != null) 'order_id': orderId,
    };
  }
}
