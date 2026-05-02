import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../wallet/domain/entities/wallet.dart';

/// Displays the wallet balance. Shows a shimmer skeleton while loading.
class WalletCard extends StatelessWidget {
  const WalletCard({super.key, required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return _WalletCardContent(wallet: wallet);
  }
}

/// Skeleton placeholder shown while the wallet balance is being fetched.
class WalletCardSkeleton extends StatefulWidget {
  const WalletCardSkeleton({super.key});

  @override
  State<WalletCardSkeleton> createState() => _WalletCardSkeletonState();
}

class _WalletCardSkeletonState extends State<WalletCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _shimmer = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.borderXxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label skeleton
              _ShimmerBox(width: 100, height: 12, opacity: _shimmer.value),
              const SizedBox(height: AppSpacing.base),
              // Balance skeleton
              _ShimmerBox(width: 200, height: 44, opacity: _shimmer.value),
              const SizedBox(height: AppSpacing.base),
              // Currency skeleton
              _ShimmerBox(width: 60, height: 14, opacity: _shimmer.value),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.opacity,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: opacity),
        borderRadius: AppRadius.borderMd,
      ),
    );
  }
}

class _WalletCardContent extends StatelessWidget {
  const _WalletCardContent({required this.wallet});

  final Wallet wallet;

  String _formatBalance(double balance, String currency) {
    final symbol = _currencySymbol(currency);
    final formatted = balance.toStringAsFixed(2);
    // Add thousands separator
    final parts = formatted.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '$symbol$buffer.$decPart';
  }

  String _currencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'INR':
        return '₹';
      default:
        return currency;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.borderXxl,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLevel2,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.inversePrimary.withValues(alpha: 0.78),
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            _formatBalance(wallet.balance, wallet.currency),
            style: AppTypography.h1.copyWith(
              color: AppColors.onPrimary,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            wallet.currency.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.inversePrimary.withValues(alpha: 0.6),
              letterSpacing: 1.5,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
