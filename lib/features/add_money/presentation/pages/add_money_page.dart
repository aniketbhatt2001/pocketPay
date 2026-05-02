import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/add_money_cubit.dart';
import '../widgets/amount_input.dart';
import '../widgets/pay_button.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({super.key});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAdd() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    final phone = Supabase.instance.client.auth.currentUser?.phone ?? '';

    // razorpayKeyId is already baked into the cubit via AppConfig at creation.
    context.read<AddMoneyCubit>().initiatePayment(
      amount: amount,
      userPhone: phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        title: Text(
          'Add Money',
          style: AppTypography.h2.copyWith(fontSize: 18),
        ),
      ),
      body: BlocListener<AddMoneyCubit, AddMoneyState>(
        listener: (context, state) {
          if (state is AddMoneySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Money added successfully!')),
            );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AmountInput(controller: _amountController),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AddMoneyCubit, AddMoneyState>(
                builder:
                    (context, state) => PayButton(
                      onPressed: _onAdd,
                      isLoading:
                          state is AddMoneyProcessing ||
                          state is AddMoneyUpdatingWallet,
                      label: 'Add Money',
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
