import 'dart:developer';

import 'package:pocket_pay_demo/features/auth/data/models/auth_model.dart';
import '../../../../core/services/supabase_auth_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service);

  final SupabaseAuthService _service;

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
    // 1. Verify OTP with Supabase Auth.
    final user = await _service.verifyOtp(
      phoneNumber: verificationId,
      token: smsCode,
    );

    // 2. Fetch the public profile via edge function.
    final profile = await _fetchUserById(user.id);

    return AuthUser(
      uid: user.id,
      phoneNumber: user.phone ?? verificationId,
      createdAt: DateTime.tryParse(user.createdAt),
      fullName: profile['full_name'] as String?,
      biometricEnabled: (profile['biometric_enabled'] as bool?) ?? false,
      isMpinSet: (profile['is_mpin_set'] as bool?) ?? false,
    );
  }

  @override
  Future<void> setMpin({
    required String userId,
    required String rawMpin,
  }) async {
    final response = await _service.invokeFn(
      'set-mpin',
      body: {'raw_mpin': rawMpin},
    );

    if (response.status != 200) {
      final message =
          (response.data as Map<String, dynamic>?)?['error'] as String? ??
          'Failed to set MPIN';
      throw Exception(message);
    }
  }

  @override
  Future<AuthUser?> hasActiveSession() async {
    final active = await _service.hasActiveSession();
    log('hasActiveSession $active');
    if (!active) return null;

    final id = _service.currentUser?.id;
    log('id $id');
    if (id == null) return null;

    // Fetch user profile via edge function — no direct DB query here.
    final row = await _fetchUserById(id);

    final authModel = AuthModel.fromJson(row);
    log('authModel ${authModel.toJson()}');
    return authModel.toEntity();
  }

  @override
  Future<void> signOut() => _service.signOut();

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Calls the `get-user` edge function and returns the user profile map.
  ///
  /// Throws an [Exception] if the function returns a non-200 status.
  Future<Map<String, dynamic>> _fetchUserById(String id) async {
    final response = await _service.invokeFn(
      'get-user',
      queryParams: {'id': id},
    );

    if (response.status != 200) {
      final message =
          (response.data as Map<String, dynamic>?)?['error'] as String? ??
          'Failed to fetch user profile';
      throw Exception(message);
    }

    return (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
  }
}
