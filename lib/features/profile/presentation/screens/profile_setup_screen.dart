import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/di/service_locator.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_pay_demo/features/profile/presentation/cubit/profile_setup_cubit.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/widgets/login_background.dart';

/// Entry point — injects dependencies and wraps the view.
class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileSetupCubit>(),
      child: const _ProfileSetupView(),
    );
  }
}

// ── View ───────────────────────────────────────────────────────────────────

class _ProfileSetupView extends StatefulWidget {
  const _ProfileSetupView();

  @override
  State<_ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<_ProfileSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  // Focus nodes for keyboard traversal
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    context.read<ProfileSetupCubit>().submit(
      userId: authState.user.uid,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //context.read<ProfileSetupCubit>().reset();
    return BlocListener<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        if (state is ProfileSetupSuccess) {
          context.read<AuthBloc>().add(AppStarted());
          // Navigate to wallet and clear the back stack
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.wallet, (_) => false);
        } else if (state is ProfileSetupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
            ),
          );
          context.read<ProfileSetupCubit>().reset();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const _ProfileSetupAppBar(),
        body: Stack(
          children: [
            const LoginBackground(),
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.containerMargin,
                  right: AppSpacing.containerMargin,
                  top: AppSpacing.lg,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHero(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildForm(),
                    const SizedBox(height: AppSpacing.md),
                    _buildSubmitButton(),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ],
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
            Icons.person_rounded,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Set Up Your Profile',
          style: AppTypography.h1.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Tell us a bit about yourself so we can personalise your experience.',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Form ───────────────────────────────────────────────────────────────────

  Widget _buildForm() {
    final authState = context.watch<AuthBloc>().state;
    final phone =
        authState is AuthAuthenticated ? authState.user.phoneNumber : '';

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First name
          _FieldLabel(label: 'First Name'),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: _firstNameController,
            focusNode: _firstNameFocus,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => _lastNameFocus.requestFocus(),
            decoration: _inputDecoration(
              hint: 'Enter your first name',
              prefixIcon: Icons.person_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First name is required.';
              }
              if (value.trim().length < 2) {
                return 'First name must be at least 2 characters.';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.gutter),

          // Last name
          _FieldLabel(label: 'Last Name'),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: _lastNameController,
            focusNode: _lastNameFocus,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => _emailFocus.requestFocus(),
            decoration: _inputDecoration(
              hint: 'Enter your last name',
              prefixIcon: Icons.person_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Last name is required.';
              }
              if (value.trim().length < 2) {
                return 'Last name must be at least 2 characters.';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.gutter),

          // Email
          _FieldLabel(label: 'Email Address'),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_) => _submit(),
            decoration: _inputDecoration(
              hint: 'Enter your email address',
              prefixIcon: Icons.email_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email address is required.';
              }
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email address.';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.gutter),

          // Mobile number — read-only
          _FieldLabel(label: 'Mobile Number'),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            initialValue: phone,
            readOnly: true,
            decoration: _inputDecoration(
              hint: 'Mobile number',
              prefixIcon: Icons.phone_outlined,
              suffixIcon: Icons.lock_outline_rounded,
            ).copyWith(
              fillColor: AppColors.surfaceContainerHigh,
              hintStyle: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.onSurfaceVariant),
      suffixIcon:
          suffixIcon != null
              ? Icon(suffixIcon, size: 18, color: AppColors.outline)
              : null,
    );
  }

  // ── Submit button ──────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        final isLoading = state is ProfileSetupLoading;
        return AppButton(
          onPressed: isLoading ? null : _submit,
          isLoading: isLoading,
          text: 'Save & Continue',
        );
      },
    );
  }
}

// ── Field label ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelSm.copyWith(
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────

class _ProfileSetupAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ProfileSetupAppBar();

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
              Text(
                'PocketPay',
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
