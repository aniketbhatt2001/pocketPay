import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        appBar: const _DashboardAppBar(),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _BalanceCard(),
                SizedBox(height: AppSpacing.gutter),
                _AddMoneyButton(),
                SizedBox(height: AppSpacing.base),
                _SendMoneyButton(),
                SizedBox(height: AppSpacing.md),
                _RecentTransactions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: AppShadows.level1,
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
              // Logo + brand name
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

// ── Balance Card ───────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

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
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.inversePrimary.withAlpha(200),
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            '\$12,450.80',
            style: AppTypography.h1.copyWith(
              color: AppColors.onPrimary,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Money Button ───────────────────────────────────────────────────────

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: AppRadius.borderXl,
      child: InkWell(
        onTap: () {},
        borderRadius: AppRadius.borderXl,
        splashColor: AppColors.primaryFixed,
        highlightColor: AppColors.primaryFixed.withAlpha(80),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderXl,
            boxShadow: AppShadows.level1,
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

// ── Send Money Button ──────────────────────────────────────────────────────

class _SendMoneyButton extends StatelessWidget {
  const _SendMoneyButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryContainer,
      borderRadius: AppRadius.borderXl,
      child: InkWell(
        onTap: () {},
        borderRadius: AppRadius.borderXl,
        splashColor: AppColors.primary,
        highlightColor: AppColors.primary.withAlpha(60),
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

// ── Recent Transactions ────────────────────────────────────────────────────

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  static const _transactions = [
    _Transaction(name: 'Apple Store', amount: '-\$1,299.00', isCredit: false),
    _Transaction(name: 'Starbucks Coffee', amount: '-\$12.50', isCredit: false),
    _Transaction(name: 'Rahul', amount: '₹500.00', isCredit: true),
  ];

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
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppRadius.borderXl,
            boxShadow: AppShadows.level1,
          ),
          child: Column(
            children: [
              for (int i = 0; i < _transactions.length; i++) ...[
                _TransactionTile(transaction: _transactions[i]),
                if (i < _transactions.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.outlineVariant.withAlpha(100),
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
            onPressed: () {},
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

class _Transaction {
  final String name;
  final String amount;
  final bool isCredit;

  const _Transaction({
    required this.name,
    required this.amount,
    required this.isCredit,
  });
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final _Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            transaction.name,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            transaction.amount,
            style: AppTypography.bodyMd.copyWith(
              color:
                  transaction.isCredit
                      ? AppColors.secondary
                      : AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
