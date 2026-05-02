/// Lightweight domain entity representing an authenticated user.
///
/// Intentionally does NOT include sensitive server-only fields such as
/// `mpin_hash`. Those columns must never leave the data layer.
class AuthUser {
  const AuthUser({
    required this.uid,
    required this.phoneNumber,
    this.createdAt,
    this.fullName,
    this.biometricEnabled = false,
    this.isMpinSet = false,
  });

  final String uid;
  final String phoneNumber;
  final String? fullName;
  final bool biometricEnabled;
  final DateTime? createdAt;
  final bool isMpinSet;

  @override
  String toString() =>
      'AuthUser(uid: $uid, phone: $phoneNumber, createdAt: $createdAt , isMpinSet: $isMpinSet)';
}
