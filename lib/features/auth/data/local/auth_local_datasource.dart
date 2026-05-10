import 'package:drift/drift.dart';
import 'package:pocket_pay_demo/core/database/app_database.dart';
import 'package:pocket_pay_demo/features/auth/data/models/auth_model.dart';

/// Persists and retrieves the authenticated user's profile from the local
/// SQLite database so the app can restore a session without a network call.
class AuthLocalDatasource {
  AuthLocalDatasource(this._db);

  final AppDatabase _db;

  /// Returns the cached [AuthModel] for [userId], or null if not yet stored.
  Future<AuthModel?> getCachedUser(String userId) async {
    final row = await _db.getCachedUser(userId);
    if (row == null) return null;
    return AuthModel(
      uid: row.id,
      phoneNumber: row.phoneNumber,
      firstName: row.firstName,
      lastName: row.lastName,
      email: row.email,
      biometricEnabled: row.biometricEnabled,
      isMpinSet: row.isMpinSet,
      isProfileComplete: row.isProfileComplete,
      createdAt: row.createdAt,
    );
  }

  /// Saves (or updates) the user profile in the local cache.
  Future<void> saveUser(AuthModel user) async {
    await _db.upsertUser(
      CachedUsersTableCompanion(
        id: Value(user.uid),
        phoneNumber: Value(user.phoneNumber),
        firstName: Value(user.firstName),
        lastName: Value(user.lastName),
        email: Value(user.email),
        biometricEnabled: Value(user.biometricEnabled),
        isMpinSet: Value(user.isMpinSet),
        isProfileComplete: Value(user.isProfileComplete),
        createdAt: Value(user.createdAt),
      ),
    );
  }
}
