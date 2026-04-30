import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles phone OTP authentication using Supabase.
class SupabaseAuthService {
  SupabaseAuthService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Currently signed-in user, if any.
  User? get currentUser => _client.auth.currentUser;

  /// Listen to login/logout state changes.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Returns true if the user already has a valid session.
  Future<bool> hasActiveSession() async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) return false;
      return !session.isExpired;
    } catch (_) {
      return false;
    }
  }

  /// Sends OTP to the given phone number.
  ///
  /// Returns the phone number so it can be reused during verification.
  Future<String> sendOtp({required String phoneNumber}) async {
    try {
      await _client.auth.signInWithOtp(phone: phoneNumber);
      return phoneNumber;
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (_) {
      throw Exception('Failed to send OTP. Please try again.');
    }
  }

  /// Verifies the OTP and signs the user in.
  Future<User> verifyOtp({
    required String phoneNumber,
    required String token,
  }) async {
    try {
      final response = await _client.auth.verifyOTP(
        phone: phoneNumber,
        token: token,
        type: OtpType.sms,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Verification failed. Please try again.');
      }

      return user;
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Verification failed. Please try again.');
    }
  }

  /// Logs out the current user.
  Future<void> signOut() => _client.auth.signOut();

  String _mapAuthError(AuthException e) {
    final msg = e.message.toLowerCase();

    if (msg.contains('invalid') && msg.contains('otp')) {
      return 'The code you entered is incorrect. Please try again.';
    }

    if (msg.contains('expired')) {
      return 'The verification code has expired. Please request a new one.';
    }

    if (msg.contains('phone')) {
      return 'The phone number is not valid. Please check and try again.';
    }

    if (msg.contains('rate') || msg.contains('too many')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }

    return e.message.isNotEmpty ? e.message : 'An unexpected error occurred.';
  }
}
