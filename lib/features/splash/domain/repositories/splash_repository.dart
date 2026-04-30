/// Contract for session-check operations used by the splash feature.
abstract class SplashRepository {
  /// Returns `true` if the user has a valid, non-expired session.
  Future<bool> hasActiveSession();

  /// Returns `true` if the authenticated user has already set an MPIN.
  Future<bool> isMpinSet();
}
