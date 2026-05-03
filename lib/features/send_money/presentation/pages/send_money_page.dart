import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_pay_demo/features/auth/presentation/screens/enter_mpin_screen.dart';
import 'package:pocket_pay_demo/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:pocket_pay_demo/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:pocket_pay_demo/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/send_money.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/send_money_cubit.dart';
import '../widgets/amount_input.dart';
import '../widgets/note_input.dart';
import '../widgets/pay_button.dart';
import '../widgets/recipient_input.dart';

class SendMoneyPage extends StatefulWidget {
  final VoidCallback onMoneySent;
  const SendMoneyPage(this.onMoneySent, {super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onPay(SendMoneyCubit sendMoneyCubit) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final recipient = _recipientController.text.trim();
    final amountText = _amountController.text.trim();
    final note = _noteController.text.trim();

    if (recipient.isEmpty || amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    sendMoneyCubit.send(
      recipientPhone: recipient,
      amount: amount,
      note: note.isEmpty ? null : note,
      senderUserId: authState.user.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SendMoneyCubit(
            sendMoney: SendMoneyUseCase(
              WalletRepositoryImpl(WalletRemoteDatasource()),
            ),
          ),
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceContainerLowest,
          elevation: 0,
          title: Text(
            'Send Money',
            style: AppTypography.h2.copyWith(fontSize: 18),
          ),
        ),
        body: BlocListener<SendMoneyCubit, SendMoneyState>(
          listener: (context, state) {
            if (state is SendMoneySuccess) {
              widget.onMoneySent();
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Money sent successfully!')),
              );
            } else if (state is SendMoneyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.containerMargin),
            child: Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RecipientInput(controller: _recipientController),
                  const SizedBox(height: AppSpacing.gutter),
                  AmountInput(controller: _amountController),
                  const SizedBox(height: AppSpacing.gutter),
                  NoteInput(controller: _noteController),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<SendMoneyCubit, SendMoneyState>(
                    builder:
                        (context, state) => PayButton(
                          onPressed: () async {
                            //

                            if (globalKey!.currentState!.validate()) {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => EnterMpinScreen(
                                        onContinue: (pin) {
                                          // verify pin, proceed with payment, etc.
                                        },
                                      ),
                                ),
                              );
                              _onPay(context.read<SendMoneyCubit>());
                            }
                          },
                          isLoading: state is SendMoneyLoading,
                          label: 'Send Money',
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
