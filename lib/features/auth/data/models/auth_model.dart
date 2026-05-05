import '../../domain/entities/auth_user.dart';

/// Data model for [AuthUser] that handles JSON serialization/deserialization.
///
/// Extends [AuthUser] so it can be used anywhere the domain entity is expected.
class AuthModel extends AuthUser {
  const AuthModel({
    required super.uid,
    required super.phoneNumber,

    super.firstName,
    super.lastName,
    super.email,
    super.biometricEnabled,
    super.createdAt,
    super.isMpinSet,
    super.isProfileComplete,
  });

  /// Creates an [AuthModel] from a JSON map (e.g. a Supabase row).
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      uid: json['id'] as String,
      phoneNumber: json['phone_number'] as String,

      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      isMpinSet: json['is_mpin_set'] as bool? ?? false,
      isProfileComplete: json['is_profile_complete'] as bool? ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  /// Converts this model to a JSON map suitable for persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'phone_number': phoneNumber,

      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'biometric_enabled': biometricEnabled,
      'is_mpin_set': isMpinSet,
      'created_at': createdAt?.toIso8601String(),
      'is_profile_complete': isProfileComplete,
    };
  }

  /// Creates an [AuthModel] from a domain [AuthUser] entity.
  factory AuthModel.fromEntity(AuthUser entity) {
    return AuthModel(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,

      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      biometricEnabled: entity.biometricEnabled,
      isMpinSet: entity.isMpinSet,
      createdAt: entity.createdAt,
      isProfileComplete: entity.isProfileComplete,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      uid: uid,
      phoneNumber: phoneNumber,

      firstName: firstName,
      lastName: lastName,
      email: email,
      biometricEnabled: biometricEnabled,
      isMpinSet: isMpinSet,
      createdAt: createdAt,
      isProfileComplete: isProfileComplete,
    );
  }
}
