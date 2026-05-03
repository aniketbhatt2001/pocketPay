import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

class RecipientInput extends StatelessWidget {
  const RecipientInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipient Phone',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter recipient phone number';
            }
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+1 555 000 1234',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: AppRadius.borderXl,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
