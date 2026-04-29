import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around [FirebaseAuth] for phone authentication.
class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// The currently signed-in user, or null.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth-state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Starts the phone-number verification flow and waits until Firebase either
  /// sends the OTP or reports an error.
  ///
  /// Uses a [Completer] to bridge Firebase's callback-based API into a proper
  /// awaitable future — this prevents the "emit after handler completed" error
  /// in flutter_bloc, which occurs because [FirebaseAuth.verifyPhoneNumber]
  /// resolves its own future immediately after registering callbacks, not after
  /// the callbacks actually fire.
  ///
  /// [phoneNumber] must be in E.164 format, e.g. `+15550001234`.
  /// Returns the verificationId on success, throws on failure.
  Future<String> verifyPhoneNumber({
    required String phoneNumber,
  }) async {
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-verification (Android only) — resolve with a sentinel so the
        // caller knows it can sign in immediately with the credential.
        if (!completer.isCompleted) {
          // Store credential for auto sign-in; resolve with empty string as
          // signal. Callers that need auto-sign-in should use authStateChanges.
          completer.complete('__auto__');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(_mapAuthError(e));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (_) {
        // Timeout fires after 60 s; only complete if nothing else did.
        if (!completer.isCompleted) {
          completer.completeError('SMS timed out. Please request a new code.');
        }
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  /// Signs in with the [verificationId] + [smsCode] pair.
  ///
  /// Returns the signed-in [User] on success.
  /// Throws a [FirebaseAuthException] on failure.
  Future<User> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.user!;
  }

  /// Signs the current user out.
  Future<void> signOut() => _auth.signOut();

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number is not valid. Please check and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'invalid-verification-code':
        return 'The code you entered is incorrect. Please try again.';
      case 'session-expired':
        return 'The verification code has expired. Please request a new one.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}
