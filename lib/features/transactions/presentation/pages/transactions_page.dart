import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/transactions_cubit.dart';
import '../widgets/transaction_item.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionsCubit>().loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        title: Text(
          'Transactions',
          style: AppTypography.h2.copyWith(fontSize: 18),
        ),
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state is TransactionsLoading || state is TransactionsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is TransactionsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 40,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.base),
                    TextButton(
                      onPressed:
                          () =>
                              context
                                  .read<TransactionsCubit>()
                                  .loadTransactions(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return Center(
                child: Text(
                  'No transactions yet.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
              itemCount: state.transactions.length,
              separatorBuilder:
                  (_, __) => Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.outlineVariant.withValues(alpha: 0.39),
                    indent: AppSpacing.containerMargin,
                    endIndent: AppSpacing.containerMargin,
                  ),
              itemBuilder: (context, index) {
                return Container(
                  color: AppColors.surfaceContainerLowest,
                  child: TransactionItem(
                    transaction: state.transactions[index],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
