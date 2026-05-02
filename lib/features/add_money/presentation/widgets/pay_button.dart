import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';

class PayButton extends StatelessWidget {
  const PayButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Add Money',
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppButton(text: label, onPressed: onPressed, isLoading: isLoading);
  }
}
