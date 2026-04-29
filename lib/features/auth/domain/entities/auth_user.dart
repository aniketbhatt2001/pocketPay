/// Lightweight domain entity representing an authenticated user.
class 
AuthUser {
  const AuthUser({
    required this.uid,
    required this.phoneNumber,
    this.createdAt,
    this.mpinHash,
    this.fullName,
    this.biometricEnabled = false,
  });

  final String uid;
  final String phoneNumber;
  final String? mpinHash;
  final String? fullName;
  final bool biometricEnabled;
  final DateTime? createdAt;

  @override
  String toString() => 'AuthUser(uid: $uid, phone: $phoneNumber createdAt: $createdAt)';
}
