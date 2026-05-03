import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/verify_mpin_usecase.dart';

import '../../domain/usecases/set_mpin_usecase.dart';

part 'mpin_state.dart';

class MpinCubit extends Cubit<MpinState> {
  MpinCubit({
    required SetMpinUseCase setMpinUseCase,
    required VerifyMpinUseCase verifyMpinUseCase,
  }) : _setMpin = setMpinUseCase,
       _verifyMpin = verifyMpinUseCase,
       super(const MpinInitial());

  final SetMpinUseCase _setMpin;
  final VerifyMpinUseCase _verifyMpin;
  Future<void> saveMpin({
    required String userId,
    required String rawMpin,
  }) async {
    try {
      emit(const MpinLoading());
      await _setMpin(userId: userId, rawMpin: rawMpin);
      emit(const MpinSuccess());
    } catch (e) {
      log(e.toString());
      emit(MpinError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> verifyMpin({
    required String userId,
    required String rawMpin,
  }) async {
    try {
      emit(const MpinLoading());
      final res = await _verifyMpin(userId: userId, rawMpin: rawMpin);
      res.fold(
        onSuccess: (data) {
          if (data) {
            emit(MpinSuccess());
          } else {
            emit(MpinError("Wrong pin entered"));
          }
          // emit(MpinSuccess());
        },
        onFailure: (failure) {
          emit(MpinError(failure.message));
        },
      );
      // if(res.isFailure){
      //   MpinError(res.)
      // }
      // emit(const MpinSuccess());
    } catch (e) {
      log(e.toString());
      emit(MpinError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void reset() => emit(const MpinInitial());
}
