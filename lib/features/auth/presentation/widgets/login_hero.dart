import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Shield icon circle
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
            boxShadow: AppShadows.level2,
          ),
          child: const Icon(
            Icons.shield_outlined,
            size: 48,
            color: AppColors.primaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Headline
        Text(
          'Welcome back',
          style: AppTypography.h1.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Sub-headline
        Text(
          'Securely access your digital wallet\nwith your mobile number.',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
