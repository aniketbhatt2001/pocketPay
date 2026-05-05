import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/set_user_profile_usecase.dart';

part 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit({required SetUserProfileUseCase updateProfileUseCase})
    : _setUserProfile = updateProfileUseCase,
      super(const ProfileSetupInitial());

  final SetUserProfileUseCase _setUserProfile;

  Future<void> submit({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    emit(const ProfileSetupLoading());
    print(" _setUserProfile..........");
    final result = await _setUserProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
    print(result);
    result.fold(
      onSuccess: (profile) => emit(ProfileSetupSuccess()),
      onFailure: (failure) => emit(ProfileSetupFailure(failure.message)),
    );
  }

  void reset() => emit(const ProfileSetupInitial());
}
