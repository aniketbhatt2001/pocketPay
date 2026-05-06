import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/widgets/transaction_item.dart';

/// Recent transactions section shown on the home page as a sliver.
class AllTransactionsSliver extends StatelessWidget {
  const AllTransactionsSliver({
    super.key,
    required this.transactions,
    this.onViewAll,
  });

  final List<Transaction> transactions;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(child: _EmptyTransactions());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        // First item: top-rounded container header
        // Last item: bottom-rounded container footer
        final isFirst = index == 0;
        final isLast = index == transactions.length - 1;

        final borderRadius = BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(16) : Radius.zero,
          topRight: isFirst ? const Radius.circular(16) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
        );

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: borderRadius,
            boxShadow:
                isFirst
                    ? const [
                      BoxShadow(
                        color: AppColors.shadowLevel1,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ]
                    : null,
          ),
          child: TransactionItem(transaction: transactions[index]),
        );
      }, childCount: transactions.length),
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
