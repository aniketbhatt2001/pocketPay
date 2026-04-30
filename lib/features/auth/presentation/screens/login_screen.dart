import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/services/supabase_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../screens/otp_screen.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_input_card.dart';
import '../widgets/login_security_note.dart';
import '../widgets/login_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepositoryImpl(SupabaseAuthService());
    return BlocProvider(
      create: (_) => AuthBloc(
        sendOtpUseCase: SendOtpUseCase(repo),
        verifyOtpUseCase: VerifyOtpUseCase(repo),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _e164Phone {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return '+91$digits';
  }

  void _onContinue() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      _focusNode.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit number.')),
      );
      return;
    }
    print(_e164Phone);
    context.read<AuthBloc>().add(SendOtpRequested(_e164Phone));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          Navigator.of(context).push(
            MaterialPageRoute(
              // Pass the same bloc instance so OTP screen shares state.
              builder: (_) => BlocProvider.value(
                value: context.read<AuthBloc>(),
                child: OtpScreen(phoneNumber: state.phoneNumber),
              ),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<AuthBloc>().add(const AuthReset());
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: _LoginAppBar(),
            body: Stack(
              children: [
                const LoginBackground(),
                SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.containerMargin,
                      vertical: AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        const LoginHero(),
                        const SizedBox(height: AppSpacing.xl),
                        LoginInputCard(
                          controller: _phoneController,
                          focusNode: _focusNode,
                          onContinue: isLoading ? () {} : _onContinue,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const LoginSecurityNote(),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: AppShadows.level1,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PocketPay',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help_outline_rounded),
                color: AppColors.onSurfaceVariant,
                iconSize: 24,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
