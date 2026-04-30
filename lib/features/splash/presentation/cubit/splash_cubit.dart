import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_mpin_usecase.dart';
import '../../domain/usecases/check_session_usecase.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required CheckSessionUseCase checkSession,
    required CheckMpinUseCase checkMpin,
  }) : _checkSession = checkSession,
       _checkMpin = checkMpin,
       super(const SplashInitial());

  final CheckSessionUseCase _checkSession;
  final CheckMpinUseCase _checkMpin;

  Future<void> checkSession() async {
    try {
      final hasSession = await _checkSession();

      if (!hasSession) {
        emit(const SplashUnauthenticated());
        return;
      }

      // Session is valid — now check whether MPIN has been configured.
      final mpinSet = await _checkMpin();
      emit(mpinSet ? const SplashAuthenticated() : const SplashMpinRequired());
    } catch (_) {
      emit(const SplashUnauthenticated());
    }
  }
}
