import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  })  : _sendOtp = sendOtpUseCase,
        _verifyOtp = verifyOtpUseCase,
        super(const AuthInitial()) {
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<AuthReset>(_onReset);
  }

  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;

  /// Stored between SendOtp and VerifyOtp events.
  String? _verificationId;
  String? _lastPhoneNumber;

  // ── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _onSendOtp(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    _lastPhoneNumber = event.phoneNumber;

    try {
      // sendOtp now returns a Future<String> that only resolves once Firebase
      // has actually sent the SMS (or throws on failure). No callbacks cross
      // the handler boundary, so emit is always called before the handler ends.
      final verificationId = await _sendOtp(phoneNumber: event.phoneNumber);
      _verificationId = verificationId;
      emit(OtpSent(event.phoneNumber));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_verificationId == null) {
      emit(const AuthError('Session expired. Please request a new code.'));
      return;
    }
    emit(const AuthLoading());

    try {
      final user = await _verifyOtp(
        verificationId: _verificationId!,
        smsCode: event.smsCode,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_lastPhoneNumber == null) return;
    emit(const AuthLoading());

    try {
      final verificationId = await _sendOtp(phoneNumber: _lastPhoneNumber!);
      _verificationId = verificationId;
      emit(OtpSent(_lastPhoneNumber!));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onReset(AuthReset event, Emitter<AuthState> emit) {
    _verificationId = null;
    _lastPhoneNumber = null;
    emit(const AuthInitial());
  }
}
