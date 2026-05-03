import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/widgets/app_button.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_background.dart';
import '../widgets/otp_input_row.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _canResend = false;
  int _secondsLeft = 60;
  late final _sub = Stream.periodic(const Duration(seconds: 1)).listen((_) {
    if (!mounted) return;
    setState(() {
      if (_secondsLeft > 0) {
        _secondsLeft--;
      } else {
        _canResend = true;
      }
    });
  });

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _resetTimer() {
    setState(() {
      _canResend = false;
      _secondsLeft = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.wallet, (_) => false);
        } else if (state is AuthUnAuthenticated) {
          if (state.msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.msg!),
                backgroundColor: AppColors.error,
              ),
            );
          }
          // Stay on OTP screen — user can retry
        } else if (state is OtpSent) {
          // Resend succeeded — restart the countdown
          _resetTimer();
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
            appBar: _OtpAppBar(
              onBack: () {
                context.read<AuthBloc>().add(const AuthReset());
                Navigator.of(context).pop();
              },
            ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        _buildHero(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildCard(context, isLoading),
                        const SizedBox(height: AppSpacing.md),
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

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
            boxShadow: AppShadows.level2,
          ),
          child: const Icon(
            Icons.sms_outlined,
            size: 48,
            color: AppColors.primaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Enter verification code',
          style: AppTypography.h1.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We sent a 6-digit code to\n${widget.phoneNumber}',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.borderXl,
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              'VERIFICATION CODE',
              style: AppTypography.labelSm.copyWith(color: AppColors.primary),
            ),
          ),
          OtpInputRow(
            enabled: !isLoading,
            onCompleted: (otp) {
              if (!isLoading) {
                context.read<AuthBloc>().add(
                  VerifyOtpRequested(otp, widget.phoneNumber),
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            onPressed: null,
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.onPrimary,
                      ),
                    )
                    : Text(
                      'Enter all 6 digits to verify',
                      style: AppTypography.button.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.7),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

// ── App bar ──────────────────────────────────────────────────────────────────

class _OtpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _OtpAppBar({required this.onBack});

  final VoidCallback onBack;

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
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.onSurfaceVariant,
                iconSize: 24,
              ),
              Text(
                'PocketPay',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}
