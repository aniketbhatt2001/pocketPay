import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around [SupabaseClient] for phone-based OTP authentication.
class SupabaseAuthService {
  SupabaseAuthService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// The currently signed-in user, or null.
  User? get currentUser => _client.auth.currentUser;

  /// Stream of auth-state changes.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Sends an OTP to [phoneNumber] (E.164 format, e.g. `+15550001234`).
  ///
  /// Supabase does not return a verificationId — the phone number itself is
  /// used as the session key when verifying. Returns [phoneNumber] so the
  /// caller can store it as the "verificationId" in the domain layer.
  ///
  /// Throws a descriptive [Exception] on failure.
  Future<String> sendOtp({required String phoneNumber}) async {
    try {
      await _client.auth.signInWithOtp(phone: phoneNumber);
      return phoneNumber; // used as verificationId in the domain layer
    } on AuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (e) {
      throw Exception('Failed to send OTP. Please try again.');
    }
  }

  /// Verifies the OTP token for [phoneNumber] and signs the user in.
  ///
  /// A database trigger (`on_auth_user_created`) automatically creates the
  /// matching row in `public.users` — no client-side insert needed here.
  ///
  /// Returns the authenticated [User] on success.
  /// Throws a descriptive [Exception] on failure.
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

  /// Signs the current user out.
  Future<void> signOut() => _client.auth.signOut();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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
