import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Read-only profile page with a logout button.
class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnAuthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        appBar: _ProfileAppBar(),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user =
                state is AuthAuthenticated
                    ? state.user
                    : const AuthUser(uid: '', phoneNumber: '');
            return _ProfileBody(user: user);
          },
        ),
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLevel1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerMargin,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Profile',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Body ───────────────────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final AuthUser user;

  String get _displayName {
    final first = user.firstName ?? '';
    final last = user.lastName ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? 'User' : full;
  }

  String get _initials {
    final first =
        user.firstName?.isNotEmpty == true
            ? user.firstName![0].toUpperCase()
            : '';
    final last =
        user.lastName?.isNotEmpty == true
            ? user.lastName![0].toUpperCase()
            : '';
    final combined = '$first$last';
    return combined.isEmpty ? 'U' : combined;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerMargin,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Avatar + Name ──────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _initials,
                        style: AppTypography.h1.copyWith(
                          color: AppColors.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _displayName,
                    style: AppTypography.h2.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    user.phoneNumber,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Info Card ──────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: AppRadius.borderXl,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowLevel1,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'First Name',
                    value: user.firstName ?? '—',
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Last Name',
                    value: user.lastName ?? '—',
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email ?? '—',
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phoneNumber,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Logout Button ──────────────────────────────────────────────
            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

// ── Info Row ───────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Divider ────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.outlineVariant.withValues(alpha: 0.39),
      indent: AppSpacing.containerMargin,
      endIndent: AppSpacing.containerMargin,
    );
  }
}

// ── Logout Button ──────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : () => _confirmLogout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
            ),
            icon:
                isLoading
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error,
                      ),
                    )
                    : const Icon(Icons.logout_rounded, size: 20),
            label: Text(
              isLoading ? 'Signing out…' : 'Log Out',
              style: AppTypography.button.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder:
          (dialogCtx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
            title: Text(
              'Log out?',
              style: AppTypography.h2.copyWith(fontSize: 18),
            ),
            content: Text(
              'You will be signed out of your account.',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(false),
                child: Text(
                  'Cancel',
                  style: AppTypography.button.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogCtx).pop(true);
                  context.read<AuthBloc>().add(const SignOutRequested());
                },
                child: Text(
                  'Log Out',
                  style: AppTypography.button.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }
}
