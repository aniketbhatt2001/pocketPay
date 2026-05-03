import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/wallet/data/datasources/wallet_remote_datasource.dart';
import '../../../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../../../features/wallet/domain/usecases/add_money.dart';
import '../cubit/add_money_cubit.dart';

Future<bool> showAddMoneyBottomSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      final walletRepo = WalletRepositoryImpl(WalletRemoteDatasource());
      return BlocProvider(
        create:
            (_) => AddMoneyCubit(
              addMoney: AddMoneyUseCase(walletRepo),
              razorpayKeyId: AppConfig.razorpayKeyId,
            ),
        child: const AddMoneySheet(),
      );
    },
  );
  return result ?? false;
}

// ── Sheet ──────────────────────────────────────────────────────────────────

class AddMoneySheet extends StatefulWidget {
  const AddMoneySheet({super.key});

  @override
  State<AddMoneySheet> createState() => AddMoneySheetState();
}

class AddMoneySheetState extends State<AddMoneySheet> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final authState = context.read<AuthBloc>().state;
    print(authState);
    if (authState is! AuthAuthenticated) return;

    // final phone = Supabase.ins tance.client.auth.currentUser?.phone ?? '';

    context.read<AddMoneyCubit>().initiatePayment(
      amount: amount,
      userPhone: authState.user.phoneNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMoneyCubit, AddMoneyState>(
      listener: (context, state) {
        if (state is AddMoneySuccess) {
          Navigator.of(context).pop(true);
        } else if (state is AddMoneyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<AddMoneyCubit>().reset();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xxl),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerMargin,
            AppSpacing.md,
            AppSpacing.containerMargin,
            AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: AppRadius.borderFull,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                Text(
                  'Add Money',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  'Enter the amount you want to add to your wallet.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Amount field
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  autofocus: true,
                  style: AppTypography.h1.copyWith(
                    color: AppColors.onSurface,
                    fontSize: 32,
                  ),
                  decoration: InputDecoration(
                    prefixText: '₹  ',
                    prefixStyle: AppTypography.h1.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 32,
                    ),
                    hintText: '0.00',
                    hintStyle: AppTypography.h1.copyWith(
                      color: AppColors.outlineVariant,
                      fontSize: 32,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: const BorderSide(
                        color: AppColors.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: const BorderSide(
                        color: AppColors.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.containerMargin,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount.';
                    }
                    final amount = double.tryParse(value.trim());
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount greater than ₹0.';
                    }
                    if (amount < 1) {
                      return 'Minimum amount is ₹1.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.base),

                _QuickAmountRow(
                  onSelect:
                      (v) => _amountController.text = v.toStringAsFixed(0),
                ),
                const SizedBox(height: AppSpacing.md),

                // Pay button
                BlocBuilder<AddMoneyCubit, AddMoneyState>(
                  builder: (context, state) {
                    final isLoading =
                        state is AddMoneyProcessing ||
                        state is AddMoneyUpdatingWallet;
                    return FilledButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withValues(
                          alpha: 0.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderXl,
                        ),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.onPrimary,
                                ),
                              )
                              : Text(
                                'Proceed to Pay',
                                style: AppTypography.button,
                              ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.base),

                Center(
                  child: Text(
                    'Secured by Razorpay',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quick-amount chips ─────────────────────────────────────────────────────

class _QuickAmountRow extends StatelessWidget {
  const _QuickAmountRow({required this.onSelect});

  final void Function(double) onSelect;

  static const _amounts = [100.0, 500.0, 1000.0, 2000.0];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.base,
      children:
          _amounts.map((amount) {
            return ActionChip(
              label: Text(
                '₹${amount.toInt()}',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppColors.primaryFixed,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderFull),
              onPressed: () => onSelect(amount),
            );
          }).toList(),
    );
  }
}
