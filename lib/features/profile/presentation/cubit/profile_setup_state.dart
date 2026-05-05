part of 'profile_setup_cubit.dart';

sealed class ProfileSetupState {
  const ProfileSetupState();
}

final class ProfileSetupInitial extends ProfileSetupState {
  const ProfileSetupInitial();
}

final class ProfileSetupLoading extends ProfileSetupState {
  const ProfileSetupLoading();
}

final class ProfileSetupSuccess extends ProfileSetupState {
  const ProfileSetupSuccess();
}

final class ProfileSetupFailure extends ProfileSetupState {
  const ProfileSetupFailure(this.message);
  final String message;
}
