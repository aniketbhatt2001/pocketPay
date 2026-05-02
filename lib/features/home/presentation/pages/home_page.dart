import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/get_wallet_balance.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/home_cubit.dart';
import '../widgets/action_buttons.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/wallet_card.dart';

class HomePage extends StatelessWidget {
  final GetWalletBalanceUseCase getWalletBalance;
  final GetRecentTransactions getRecentTransactions;
  const HomePage(
    this.getWalletBalance,
    this.getRecentTransactions, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HomeCubit(
            getWalletBalance: getWalletBalance,
            getRecentTransactions: getRecentTransactions,
          )..loadHome(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: AppColors.surfaceContainerLow,
          appBar: const _HomeAppBar(),
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin,
                  vertical: AppSpacing.md,
                ),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Wallet Card ──────────────────────────────────────
                        if (state is HomeWalletLoading || state is HomeInitial)
                          const WalletCardSkeleton()
                        else if (state is HomeLoaded)
                          WalletCard(wallet: state.wallet)
                        else if (state is HomeError)
                          _WalletErrorCard(message: state.message),

                        const SizedBox(height: AppSpacing.gutter),

                        // ── Action Buttons ───────────────────────────────────
                        ActionButtons(
                          onAddMoney: () {
                            // TODO: navigate to add money page
                          },
                          onSendMoney: () {
                            // TODO: navigate to send money page
                          },
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // ── Recent Transactions ──────────────────────────────
                        if (state is HomeWalletLoading || state is HomeInitial)
                          const _RecentTransactionsSkeleton()
                        else if (state is HomeLoaded)
                          RecentTransactions(
                            transactions: state.recentTransactions,
                            onViewAll: () {
                              // TODO: navigate to transactions page
                            },
                          )
                        else if (state is HomeError)
                          const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.base),
                  Text(
                    'PocketPay',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Error Card ─────────────────────────────────────────────────────────────

class _WalletErrorCard extends StatelessWidget {
  const _WalletErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppRadius.borderXxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onErrorContainer.withValues(alpha: 0.7),
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.onErrorContainer,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          TextButton(
            onPressed: () => context.read<HomeCubit>().loadHome(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Retry',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onErrorContainer,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent Transactions Skeleton ───────────────────────────────────────────

class _RecentTransactionsSkeleton extends StatefulWidget {
  const _RecentTransactionsSkeleton();

  @override
  State<_RecentTransactionsSkeleton> createState() =>
      _RecentTransactionsSkeletonState();
}

class _RecentTransactionsSkeletonState
    extends State<_RecentTransactionsSkeleton>
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
      begin: 0.06,
      end: 0.18,
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label skeleton
            Container(
              width: 140,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.onSurface.withValues(alpha: _shimmer.value),
                borderRadius: AppRadius.borderMd,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: AppRadius.borderXl,
              ),
              child: Column(
                children: List.generate(3, (i) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.containerMargin,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            // Icon skeleton
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.onSurface.withValues(
                                  alpha: _shimmer.value,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            // Text skeleton
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 14,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.onSurface.withValues(
                                        alpha: _shimmer.value,
                                      ),
                                      borderRadius: AppRadius.borderMd,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 10,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: AppColors.onSurface.withValues(
                                        alpha: _shimmer.value,
                                      ),
                                      borderRadius: AppRadius.borderMd,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            // Amount skeleton
                            Container(
                              height: 14,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.onSurface.withValues(
                                  alpha: _shimmer.value,
                                ),
                                borderRadius: AppRadius.borderMd,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < 2)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.39,
                          ),
                          indent: AppSpacing.containerMargin,
                          endIndent: AppSpacing.containerMargin,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
