part of 'splash_cubit.dart';

sealed class SplashState {
  const SplashState();
}

/// Animation is playing, session check not yet complete.
final class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Session is valid and MPIN is already set — navigate to wallet.
final class SplashAuthenticated extends SplashState {
  const SplashAuthenticated();
}

/// Session is valid but MPIN has not been set yet — navigate to set-MPIN.
final class SplashMpinRequired extends SplashState {
  const SplashMpinRequired();
}

/// No valid session — navigate to login.
final class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}
