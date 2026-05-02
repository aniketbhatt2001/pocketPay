import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Add Money and Send Money action buttons shown on the home page.
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, this.onAddMoney, this.onSendMoney});

  final VoidCallback? onAddMoney;
  final VoidCallback? onSendMoney;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AddMoneyButton(onTap: onAddMoney),
        const SizedBox(height: AppSpacing.md),
        _SendMoneyButton(onTap: onSendMoney),
      ],
    );
  }
}

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: AppRadius.borderXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderXl,
        splashColor: AppColors.primaryFixed,
        highlightColor: AppColors.primaryFixed.withValues(alpha: 0.31),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderXl,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLevel1,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Icon(
                  Icons.add,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Text(
                'Add Money',
                style: AppTypography.button.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendMoneyButton extends StatelessWidget {
  const _SendMoneyButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryContainer,
      borderRadius: AppRadius.borderXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderXl,
        splashColor: AppColors.primary,
        highlightColor: AppColors.primary.withValues(alpha: 0.24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.send_rounded,
                size: 20,
                color: AppColors.onPrimary,
              ),
              const SizedBox(width: AppSpacing.base),
              Text(
                'Send Money',
                style: AppTypography.button.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
