import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

class NoteInput extends StatelessWidget {
  const NoteInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note (optional)',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Add a note…',
            prefixIcon: const Icon(Icons.notes_rounded),
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
