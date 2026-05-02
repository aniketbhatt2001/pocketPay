import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/widgets/transaction_item.dart';

/// Recent transactions section shown on the home page.
class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.transactions,
    this.onViewAll,
  });

  final List<Transaction> transactions;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT (LAST 3 TXNS)',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.1,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        if (transactions.isEmpty)
          _EmptyTransactions()
        else
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
                for (int i = 0; i < transactions.length; i++) ...[
                  TransactionItem(transaction: transactions[i]),
                  if (i < transactions.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.outlineVariant.withValues(alpha: 0.39),
                      indent: AppSpacing.containerMargin,
                      endIndent: AppSpacing.containerMargin,
                    ),
                ],
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: onViewAll,
            child: Text(
              'View All',
              style: AppTypography.button.copyWith(
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadius.borderXl,
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 32,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'No transactions yet',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
