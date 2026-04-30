import 'package:flutter/material.dart';
import 'package:pocket_pay_demo/core/theme/app_colors.dart';
import 'package:pocket_pay_demo/core/theme/app_spacing.dart';
import 'package:pocket_pay_demo/core/theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool isLoading;
  final Widget? icon;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
     this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
    this.height = 56,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primary;
    final fgColor = foregroundColor ?? AppColors.onPrimary;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(100),
          ),
          disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            fgColor.withValues(alpha: 0.08),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: fgColor,
                ),
              )
            : child !=null 
                ? child!
                : text!=null?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text!,
                      style: AppTypography.button.copyWith(
                        color: fgColor,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: AppSpacing.base),
                      icon!,
                    ],
                  ],
                ):SizedBox(),
      ),
    );
  }
}