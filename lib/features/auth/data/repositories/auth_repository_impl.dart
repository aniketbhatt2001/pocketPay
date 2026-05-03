import 'dart:developer';

import 'package:pocket_pay_demo/core/error/exceptions.dart';
import 'package:pocket_pay_demo/core/error/failures.dart';
import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/auth/data/models/auth_model.dart';
import '../../../../core/services/supabase_auth_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service);

  final SupabaseService _service;

  @override
  Future<Result<String>> sendOtp({required String phoneNumber}) async {
    try {
      final verificationId = await _service.sendOtp(phoneNumber: phoneNumber);
      return Result.success(verificationId);
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<AuthUser>> verifyOtp({
    required String phoneNumber, // contains the phone number
    required String smsCode,
  }) async {
    try {
      // 1. Verify OTP with Supabase Auth.
      final user = await _service.verifyOtp(
        phoneNumber: phoneNumber,
        token: smsCode,
      );

      // 2. Fetch the public profile via edge function.
      final profile = await _fetchUserById(user.id);

      final authUser = AuthUser(
        uid: user.id,
        phoneNumber: phoneNumber,
        createdAt: DateTime.tryParse(user.createdAt),
        fullName: profile['full_name'] as String?,
        biometricEnabled: (profile['biometric_enabled'] as bool?) ?? false,
        isMpinSet: (profile['is_mpin_set'] as bool?) ?? false,
      );

      return Result.success(authUser);
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> setMpin({
    required String userId,
    required String rawMpin,
  }) async {
    try {
      final response = await _service.invokeFn(
        'set-mpin',
        body: {'raw_mpin': rawMpin},
      );

      if (response.status != 200) {
        final message =
            (response.data as Map<String, dynamic>?)?['error'] as String? ??
            'Failed to set MPIN';
        throw ServerException(message);
      }

      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<bool>> verifyMpin({
    required String userId,
    required String rawMpin,
  }) async {
    try {
      final response = await _service.invokeFn(
        'check-mpin',
        body: {
          'raw_mpin': rawMpin, // ✅ fixed
          'user': userId,
        },
      );

      if (response.status != 200) {
        final message =
            (response.data as Map<String, dynamic>?)?['error'] as String? ??
            'Failed to verify MPIN';
        throw ServerException(message);
      }

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw InvalidResponseException("Invalid Response");
      }

      final match = data['match'];

      if (match is! bool) {
        throw InvalidResponseException("Invalid match value");
      }

      return Result.success(match); // ✅ true OR false
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<AuthUser>> hasActiveSession() async {
    try {
      final active = await _service.hasActiveSession();
      log('hasActiveSession: $active');
      if (!active) {
        return Result.failure(UnauthorizedFailure("User not Logged in"));
      }

      final id = _service.currentUser?.id;
      log('currentUser id: $id');
      if (id == null) {
        return Result.failure(UnauthorizedFailure("User not Logged in"));
      }

      final row = await _fetchUserById(id);
      final authModel = AuthModel.fromJson(row);
      log('authModel: ${authModel.toJson()}');
      return Result.success(authModel.toEntity());
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _service.signOut();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Calls the `get-user` edge function and returns the user profile map.
  ///
  /// Throws a [ServerException] if the function returns a non-200 status.
  Future<Map<String, dynamic>> _fetchUserById(String id) async {
    final response = await _service.invokeFn('get-user', body: {'id': id});

    if (response.status != 200) {
      final message =
          (response.data as Map<String, dynamic>?)?['error'] as String? ??
          'Failed to fetch user profile';
      throw ServerException(message);
    }

    return (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
  }
}
