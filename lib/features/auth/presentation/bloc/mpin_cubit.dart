import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/set_mpin_usecase.dart';

part 'mpin_state.dart';

class MpinCubit extends Cubit<MpinState> {
  MpinCubit({required SetMpinUseCase setMpinUseCase})
    : _setMpin = setMpinUseCase,
      super(const MpinInitial());

  final SetMpinUseCase _setMpin;

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

  void reset() => emit(const MpinInitial());
}
