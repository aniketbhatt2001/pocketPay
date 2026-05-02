import '../../domain/entities/auth_user.dart';

/// Data model for [AuthUser] that handles JSON serialization/deserialization.
///
/// Extends [AuthUser] so it can be used anywhere the domain entity is expected.
class AuthModel extends AuthUser {
  const AuthModel({
    required super.uid,
    required super.phoneNumber,
    super.fullName,
    super.biometricEnabled,
    super.createdAt,
    super.isMpinSet,
  });

  /// Creates an [AuthModel] from a JSON map (e.g. a Supabase row).
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      uid: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      fullName: json['full_name'] as String?,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      isMpinSet: json['is_mpin_set'] as bool? ?? false,
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
      'full_name': fullName,
      'biometric_enabled': biometricEnabled,
      'is_mpin_set': isMpinSet,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Creates an [AuthModel] from a domain [AuthUser] entity.
  factory AuthModel.fromEntity(AuthUser entity) {
    return AuthModel(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      fullName: entity.fullName,
      biometricEnabled: entity.biometricEnabled,
      isMpinSet: entity.isMpinSet,
      createdAt: entity.createdAt,
    );
  }

  // add to entity

  AuthUser toEntity() {
    return AuthUser(
      uid: uid,
      phoneNumber: phoneNumber,
      fullName: fullName,
      biometricEnabled: biometricEnabled,
      isMpinSet: isMpinSet,
      createdAt: createdAt,
    );
  }
}
