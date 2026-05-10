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
    final sign = tx.isIncoming ? '+' : '-';
    return '$sign₹${tx.amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    final local = dt.toLocal();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDay = DateTime(local.year, local.month, local.day);

    final diff = today.difference(txDay).inDays;

    final time =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    if (diff == 0) return 'Today, $time';
    if (diff == 1) return 'Yesterday, $time';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[local.month - 1]} ${local.day}, $time';
  }

  String _typeLabel(Transaction tx) {
    switch (tx.type) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.send:
        return 'Sent';
      case TransactionType.receive:
        return 'Received';
    }
  }

  IconData _typeIcon(Transaction tx) {
    switch (tx.type) {
      case TransactionType.deposit:
        return Icons.account_balance_wallet_outlined;
      case TransactionType.send:
        return Icons.arrow_upward_rounded;
      case TransactionType.receive:
        return Icons.arrow_downward_rounded;
    }
  }

  Color _iconBgColor(Transaction tx) {
    if (tx.isFailed) return AppColors.errorContainer;
    if (tx.isIncoming) return AppColors.secondaryContainer;
    return AppColors.surfaceContainerHigh;
  }

  Color _iconColor(Transaction tx) {
    if (tx.isFailed) return AppColors.error;
    if (tx.isIncoming) return AppColors.secondary;
    return AppColors.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    final tx = transaction;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconBgColor(tx),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon(tx), size: 18, color: _iconColor(tx)),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Description + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primary label: description or type
                Text(
                  tx.description?.isNotEmpty == true
                      ? tx.description!
                      : _typeLabel(tx),
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Secondary: type label (when description is shown) + date
                Row(
                  children: [
                    if (tx.description?.isNotEmpty == true) ...[
                      Text(
                        _typeLabel(tx),
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.outlineVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    Text(
                      _formatDate(tx.createdAt),
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.base),

          // Amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(tx),
                style: AppTypography.bodyMd.copyWith(
                  color:
                      tx.isFailed
                          ? AppColors.onSurfaceVariant
                          : tx.isIncoming
                          ? AppColors.secondary
                          : AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  decoration:
                      tx.isFailed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                ),
              ),
              if (!tx.isCompleted) ...[
                const SizedBox(height: 2),
                _StatusBadge(status: tx.status),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      TransactionStatus.pending => (
        'Pending',
        AppColors.primaryFixed,
        AppColors.onPrimaryFixedVariant,
      ),
      TransactionStatus.failed => (
        'Failed',
        AppColors.errorContainer,
        AppColors.onErrorContainer,
      ),
      TransactionStatus.completed => (
        '',
        Colors.transparent,
        Colors.transparent,
      ),
    };

    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
