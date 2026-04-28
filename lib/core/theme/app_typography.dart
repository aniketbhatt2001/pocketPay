import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const _fontFamily = 'Manrope';

  static const h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.02 * 32,
    color: AppColors.onSurface,
  );

  static const h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.01 * 24,
    color: AppColors.onSurface,
  );

  static const bodyLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: AppColors.onSurface,
  );

  static const bodyMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static const labelSm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
    color: AppColors.onSurfaceVariant,
  );

  static const button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 20 / 16,
    color: AppColors.onPrimary,
  );

  static TextTheme get textTheme => const TextTheme(
        displayLarge: h1,
        displayMedium: h2,
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        labelSmall: labelSm,
        labelLarge: button,
      );
}
