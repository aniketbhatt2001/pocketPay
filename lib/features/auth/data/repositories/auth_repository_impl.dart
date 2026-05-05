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
      log("verifyOtp  user ${user.toJson()}");
      // 2. Fetch the public profile via edge function.
      final profile = await _fetchUserById(user.id);
      log("_fetchUserById  Map ${profile}");
      final authUser = AuthUser(
        uid: user.id,
        phoneNumber: phoneNumber,
        createdAt: DateTime.tryParse(user.createdAt),

        biometricEnabled: (profile['biometric_enabled'] as bool?) ?? false,
        isMpinSet: (profile['is_mpin_set'] as bool?) ?? false,
        isProfileComplete: (profile['is_profile_complete'] as bool?) ?? false,
        email: (profile['email'] as String?) ?? "",
        firstName: (profile['first_name'] as String?) ?? "",
        lastName: (profile['last_name'] as String?) ?? "",
      );

      return Result.success(authUser);
    } on UnauthorizedException catch (e) {
      print(" UnauthorizedException $e");
      return Result.failure(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      print(" ServerException $e");
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      print(" mapExceptionToFailure $e");
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> setMpin({
    required String userId,
    required String rawMpin,
  }) async {
    try {
      await _service.invokeFn('set-mpin', body: {'raw_mpin': rawMpin});

      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> verifyMpin({
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

      final data = response.data;

      final match = data['match'];

      if (match is! bool) {
        throw InvalidResponseException("Invalid match value");
      }
      if (match == false) {
        return Result.failure(ServerFailure("Wrong pin entered"));
      }
      return Result.success(null); // ✅ true OR false
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
      log(row.toString());
      final authModel = AuthModel.fromJson(row);

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

    return (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
  }

  @override
  Future<Result<void>> setUserProfile({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      print("setUserProfile");
      final response = await _service.invokeFn(
        'setProfileInfo',
        body: {
          'user_id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        },
      );

      final data = response.data;

      final success = data['success'] as bool?;

      if (success == false) {
        return Result.failure(
          ServerFailure("Profile setup failed"), // map properly
        );
      }

      return Result.success(null); // ✅ true OR false
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
