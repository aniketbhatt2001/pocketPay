import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../../core/services/supabase_auth_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service) : _db = Supabase.instance.client;

  final SupabaseAuthService _service;
  final SupabaseClient _db;

  @override
  AuthUser? get currentUser {
    final user = _service.currentUser;
    if (user == null) return null;
    return AuthUser(
      uid: user.id,
      phoneNumber: user.phone ?? '',
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  @override
  Future<String> sendOtp({required String phoneNumber}) {
    // Returns the phone number as the "verificationId" — Supabase uses the
    // phone number itself to identify the pending OTP session.
    return _service.sendOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthUser> verifyOtp({
    required String verificationId, // contains the phone number
    required String smsCode,
  }) async {
    // 1. Verify OTP with Supabase Auth .
    final user = await _service.verifyOtp(
      phoneNumber: verificationId,
      token: smsCode,
    );

    // 2. Fetch the public profile
    final profile =
        await _db
            .from('users')
            .select(
              'id, phone_number, full_name, biometric_enabled, created_at',
            )
            .eq('id', user.id)
            .single();

    return AuthUser(
      uid: user.id,
      phoneNumber: user.phone ?? verificationId,
      createdAt:
          profile != null
              ? DateTime.tryParse(profile['created_at'] as String? ?? '')
              : DateTime.tryParse(user.createdAt),
      fullName: profile?['full_name'] as String?,
      biometricEnabled: (profile?['biometric_enabled'] as bool?) ?? false,
    );
  }

  @override
  Future<void> signOut() => _service.signOut();
}
