import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Decorative blurred blobs — mirrors the HTML version's fixed background blobs.
class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Top-right blob (primary-fixed tint)
            Positioned(
              top: -96,
              right: -96,
              child: _BlurBlob(
                size: 384,
                color: AppColors.primaryFixed.withOpacity(0.20),
              ),
            ),
            // Bottom-left blob (secondary-fixed tint)
            Positioned(
              bottom: -96,
              left: -96,
              child: _BlurBlob(
                size: 384,
                color: AppColors.secondaryFixed.withOpacity(0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
