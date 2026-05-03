import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_user.dart';

import '../../domain/usecases/check_session_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final CheckSessionUseCase _checkSession;
  // final CheckMpinUseCase _checkMpin;

  AuthBloc({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required CheckSessionUseCase checkSessionUseCase,
    // required CheckMpinUseCase checkMpinUseCase,
  }) : _sendOtp = sendOtpUseCase,
       _verifyOtp = verifyOtpUseCase,
       _checkSession = checkSessionUseCase,
       //  _checkMpin = checkMpinUseCase,
       super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<AuthReset>(_onReset);
  }

  //  : _sendOtp = sendOtpUseCase,

  //      _verifyOtp = verifyOtpUseCase,
  //      _checkSession = checkSessionUseCase,
  //      _checkMpin = checkMpinUseCase,

  //      super(const AuthInitial()) {
  //   on<AppStarted>(_onAppStarted);
  //   on<SendOtpRequested>(_onSendOtp);
  //   on<VerifyOtpRequested>(_onVerifyOtp);
  //   on<ResendOtpRequested>(_onResendOtp);
  //   on<AuthReset>(_onReset);

  /// Stored between SendOtp and VerifyOtp events.
  // String? _verificationId;
  String? _lastPhoneNumber;

  // ── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      log("_onAppStarted");
      emit(const AuthLoading());
      final result = await _checkSession();
      result.fold(
        onSuccess: (value) {
          emit(AuthAuthenticated(value));
        },
        onFailure: (failure) {
          emit(AuthUnAuthenticated(msg: failure.message));
        },
      );
    } catch (e) {
      emit(AuthUnAuthenticated(msg: e.toString()));
    }
  }

  Future<void> _onSendOtp(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      _lastPhoneNumber = event.phoneNumber;
      final result = await _sendOtp(phoneNumber: event.phoneNumber);
      result.fold(
        onSuccess: (value) {
          emit(OtpSent(value));
        },
        onFailure: (failure) {
          emit(AuthUnAuthenticated(msg: failure.message));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(
        AuthUnAuthenticated(msg: e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final result = await _verifyOtp(
        phoneNumber: event.phoneNumber,
        smsCode: event.smsCode,
      );
      result.fold(
        onSuccess: (value) {
          emit(AuthAuthenticated(value));
        },
        onFailure: (failure) {
          emit(AuthUnAuthenticated(msg: failure.message));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(
        AuthUnAuthenticated(msg: e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> _onResendOtp(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (_lastPhoneNumber == null) return;
      emit(const AuthLoading());
      final result = await _sendOtp(phoneNumber: _lastPhoneNumber!);
      result.fold(
        onSuccess: (value) {
          emit(OtpSent(_lastPhoneNumber!));
        },
        onFailure: (failure) {
          emit(AuthUnAuthenticated(msg: failure.message));
        },
      );
    } catch (e) {
      log(e.toString());
      emit(
        AuthUnAuthenticated(msg: e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  void _onReset(AuthReset event, Emitter<AuthState> emit) {
    _lastPhoneNumber = null;
    emit(const AuthInitial());
  }
}
