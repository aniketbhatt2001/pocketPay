import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Dropdown for selecting the source account/wallet.
class AccountSelector extends StatelessWidget {
  const AccountSelector({
    super.key,
    required this.accounts,
    required this.selectedAccount,
    required this.onChanged,
  });

  final List<String> accounts;
  final String? selectedAccount;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Account',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppRadius.borderXl,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedAccount,
              isExpanded: true,
              items:
                  accounts
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
