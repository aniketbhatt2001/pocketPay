import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/routes/app_routes.dart';
import 'package:pocket_pay_demo/features/send_money/presentation/pages/send_money_page.dart';
import 'package:pocket_pay_demo/features/transactions/domain/usecases/get_all_transactions.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/get_wallet_balance.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../add_money/presentation/widgets/add_money_bottom_sheet.dart';
import '../cubit/home_cubit.dart';
import '../widgets/action_buttons.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/wallet_card.dart';

class HomePage extends StatelessWidget {
  final GetWalletBalanceUseCase getWalletBalance;
  final GetAllTransactions getAllTransactions;
  const HomePage(this.getWalletBalance, this.getAllTransactions, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HomeCubit(
            getWalletBalance: getWalletBalance,
            getAllTransactions: getAllTransactions,
          )..loadHome(),
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        appBar: const _HomeAppBar(),
        body: Builder(
          builder: (context) {
            return SafeArea(
              top: false,
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<HomeCubit>().loadHome(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        // ── Top padding ──────────────────────────────────────
                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.md),
                        ),

                        // ── Wallet Card (floating / sticky) ──────────────────
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _WalletHeaderDelegate(
                            state: state,
                            onRetry: () => context.read<HomeCubit>().loadHome(),
                          ),
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.gutter),
                        ),

                        // ── Action Buttons ───────────────────────────────────
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.containerMargin,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Builder(
                              builder: (ctx) {
                                return ActionButtons(
                                  onAddMoney: () async {
                                    await showAddMoneyBottomSheet(context);
                                    if (ctx.mounted) {
                                      ctx.read<HomeCubit>().loadHome();
                                    }
                                  },
                                  onSendMoney: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => SendMoneyPage(() {
                                              if (ctx.mounted) {
                                                ctx
                                                    .read<HomeCubit>()
                                                    .loadHome();
                                              }
                                            }),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.md),
                        ),

                        // ── Recent Transactions ──────────────────────────────
                        if (state is HomeWalletLoading || state is HomeInitial)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.containerMargin,
                              ),
                              child: _AllTransactionsSkeleton(),
                            ),
                          )
                        else if (state is HomeLoaded)
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.containerMargin,
                            ),
                            sliver: AllTransactionsSliver(
                              transactions: state.recentTransactions,
                              onViewAll: () {
                                // TODO: navigate to transactions page
                              },
                            ),
                          )
                        else
                          const SliverToBoxAdapter(child: SizedBox.shrink()),

                        // ── Bottom padding ───────────────────────────────────
                        const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.md),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
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
              // ── Logo ──────────────────────────────────────────────────────
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

              // ── Profile Icon ──────────────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
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

class _AllTransactionsSkeleton extends StatefulWidget {
  const _AllTransactionsSkeleton();

  @override
  State<_AllTransactionsSkeleton> createState() =>
      _AllTransactionsSkeletonState();
}

class _AllTransactionsSkeletonState extends State<_AllTransactionsSkeleton>
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

// ── Wallet Persistent Header Delegate ─────────────────────────────────────

class _WalletHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _WalletHeaderDelegate({required this.state, required this.onRetry});

  final HomeState state;
  final VoidCallback onRetry;

  /// Full card height (card padding + label + balance + currency + spacing)
  static const double _expandedHeight = 148.0;

  /// Compact floating bar height
  static const double _collapsedHeight = 56.0;

  @override
  double get maxExtent => _expandedHeight + AppSpacing.md; // top padding
  @override
  double get minExtent => _collapsedHeight;

  @override
  bool shouldRebuild(_WalletHeaderDelegate old) => old.state != state;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 0.0 = fully expanded, 1.0 = fully collapsed
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final isCollapsed = t > 0.85;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Expanded card (fades out as we scroll) ──────────────────────
        Positioned(
          top: AppSpacing.md,
          left: AppSpacing.containerMargin,
          right: AppSpacing.containerMargin,
          child: Opacity(
            opacity: (1 - t * 2).clamp(0.0, 1.0),
            child: _buildExpandedContent(context),
          ),
        ),

        // ── Collapsed floating bar (fades in as we scroll) ───────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isCollapsed ? 1.0 : 0.0,
            child: _CollapsedWalletBar(state: state),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    if (state is HomeWalletLoading || state is HomeInitial) {
      return const WalletCardSkeleton();
    }
    if (state is HomeLoaded) {
      return WalletCard(wallet: (state as HomeLoaded).wallet);
    }
    if (state is HomeError) {
      return _WalletErrorCard(message: (state as HomeError).message);
    }
    return const SizedBox.shrink();
  }
}

// ── Collapsed floating balance bar ────────────────────────────────────────

class _CollapsedWalletBar extends StatelessWidget {
  const _CollapsedWalletBar({required this.state});

  final HomeState state;

  String _balance(HomeState state) {
    if (state is HomeLoaded) {
      final w = state.wallet;
      return _formatBalance(w.balance, w.currency);
    }
    return '—';
  }

  String _formatBalance(double balance, String currency) {
    final symbol = _currencySymbol(currency);
    final formatted = balance.toStringAsFixed(2);
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
      height: _WalletHeaderDelegate._collapsedHeight,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLevel2,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
      ),
      child: Row(
        children: [
          Text(
            'Balance',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.inversePrimary.withValues(alpha: 0.7),
              letterSpacing: 1.1,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '·',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.inversePrimary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _balance(state),
            style: AppTypography.h2.copyWith(
              color: AppColors.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
