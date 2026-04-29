import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class LoginSecurityNote extends StatelessWidget {
  const LoginSecurityNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_person_outlined,
            size: 20,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SECURE LOGIN PROCESS',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "By continuing, you'll receive a secure one-time verification code via SMS. Standard rates apply.",
                  style: AppTypography.bodyMd.copyWith(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
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
