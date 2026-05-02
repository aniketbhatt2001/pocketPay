import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/transaction.dart';

/// A single row in a transaction list.
class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final Transaction transaction;

  String _formatAmount(Transaction tx) {
    final sign = tx.isCredit ? '+' : '-';
    return '$sign\$${tx.amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  transaction.isCredit
                      ? AppColors.secondaryContainer
                      : AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.isCredit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 18,
              color:
                  transaction.isCredit
                      ? AppColors.secondary
                      : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (transaction.recipientName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.recipientName!,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Amount
          Text(
            _formatAmount(transaction),
            style: AppTypography.bodyMd.copyWith(
              color:
                  transaction.isCredit
                      ? AppColors.secondary
                      : AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
