import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';
import 'package:pocket_pay_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/set_mpin_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/verify_mpin_usecase.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/mpin_cubit.dart';

import '../../../../core/theme/theme.dart';
import '../widgets/login_background.dart';
import '../../../../core/widgets/app_button.dart';

/// Screen for entering an existing 6-digit MPIN.
///
/// [onContinue] is called with the entered PIN string when the user taps
/// "Continue" after filling all 6 digits.
class EnterMpinScreen extends StatelessWidget {
  const EnterMpinScreen({super.key, required this.onContinue});

  final void Function(String pin) onContinue;

  @override
  Widget build(BuildContext context) {
    return _EnterMpinView(onContinue: onContinue);
  }
}

class _EnterMpinView extends StatefulWidget {
  const _EnterMpinView({required this.onContinue});

  final void Function(String pin) onContinue;

  @override
  State<_EnterMpinView> createState() => _EnterMpinViewState();
}

class _EnterMpinViewState extends State<_EnterMpinView> {
  static const int _pinLength = 6;

  final List<int> _pin = [];

  bool get _canContinue => _pin.length == _pinLength;

  void _onDigit(int digit) {
    if (_pin.length >= _pinLength) return;
    setState(() => _pin.add(digit));
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin.removeLast());
  }

  void _onContinue() {
    if (!_canContinue) return;
    widget.onContinue(_pin.join());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = AuthRepositoryImpl(SupabaseService());
        return MpinCubit(
          setMpinUseCase: SetMpinUseCase(repo),
          verifyMpinUseCase: VerifyMpinUseCase(repo),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _EnterMpinAppBar(
          onBack: () => Navigator.of(context).maybePop(),
        ),
        body: Builder(
          builder: (context) {
            return BlocConsumer<MpinCubit, MpinState>(
              listener: (context, state) {
                // _onContinue();
                if (state is MpinSuccess) {
                  Navigator.of(context).pop();
                } else if (state is MpinError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder:
                  (context, state) => Stack(
                    children: [
                      const LoginBackground(),
                      SafeArea(
                        top: false,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.containerMargin,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: AppSpacing.lg),
                                    _buildHero(),
                                    const SizedBox(height: AppSpacing.lg),
                                    _buildPinRow(),
                                  ],
                                ),
                              ),
                            ),
                            _buildKeypad(),
                            _buildContinueButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
            );
          },
        ),
      ),
    );
  }

  // ── Hero ───────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_rounded,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Enter MPIN',
          style: AppTypography.h1.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Enter your 6-digit security PIN to continue',
          style: AppTypography.bodyMd.copyWith(color: AppColors.outline),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── PIN dot row ────────────────────────────────────────────────────────────

  Widget _buildPinRow() {
    return _PinRow(label: 'ENTER 6-DIGIT PIN', filledCount: _pin.length);
  }

  // ── Numeric keypad ─────────────────────────────────────────────────────────

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
      ),
      child: Column(
        children: [
          _buildKeyRow([1, 2, 3]),
          const SizedBox(height: AppSpacing.sm),
          _buildKeyRow([4, 5, 6]),
          const SizedBox(height: AppSpacing.sm),
          _buildKeyRow([7, 8, 9]),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              // Biometric placeholder
              Expanded(
                child: _KeypadButton(
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _KeypadButton(label: '0', onTap: () => _onDigit(0)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _KeypadButton(
                  onTap: _onBackspace,
                  child: const Icon(
                    Icons.backspace_outlined,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<int> digits) {
    return Row(
      children:
          digits.map((d) {
            final isLast = d == digits.last;
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _KeypadButton(label: '$d', onTap: () => _onDigit(d)),
                  ),
                  if (!isLast) const SizedBox(width: AppSpacing.md),
                ],
              ),
            );
          }).toList(),
    );
  }

  // ── Continue button ────────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return BlocBuilder<MpinCubit, MpinState>(
      builder:
          (context, state) => Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.containerMargin,
              AppSpacing.md,
              AppSpacing.containerMargin,
              AppSpacing.md,
            ),
            child: Builder(
              builder: (context) {
                return AppButton(
                  isLoading: state is MpinLoading,
                  onPressed:
                      _canContinue
                          ? () {
                            print(_pin);
                            final pin = _pin.join();
                            final state =
                                context
                                    .read<AuthBloc>()
                                    .state; //  context.read<MpinCubit>().verifyMpin(userId: userId, rawMpin: )
                            if (state is! AuthAuthenticated) return;

                            context.read<MpinCubit>().verifyMpin(
                              userId: state.user.uid,
                              rawMpin: pin,
                            );
                          }
                          : null,
                  child: Text(
                    'Continue',
                    style: AppTypography.button.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}

// ── PIN Row ────────────────────────────────────────────────────────────────

class _PinRow extends StatelessWidget {
  const _PinRow({required this.label, required this.filledCount});

  final String label;
  final int filledCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.primary,
            letterSpacing: 0.05 * 12,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            final filled = i < filledCount;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color:
                        filled ? AppColors.primary : AppColors.outlineVariant,
                    width: 2,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Keypad Button ──────────────────────────────────────────────────────────

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({this.label, this.child, required this.onTap})
    : assert(label != null || child != null);

  final String? label;
  final Widget? child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.borderXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderXl,
        splashColor: AppColors.primaryFixed,
        highlightColor: AppColors.primaryFixed.withAlpha(80),
        child: SizedBox(
          height: 64,
          child: Center(
            child:
                label != null
                    ? Text(
                      label!,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    )
                    : child,
          ),
        ),
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────

class _EnterMpinAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _EnterMpinAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
                'Security',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixed,
                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
