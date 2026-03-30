import 'dart:ui';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SharedContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double? blur;
  final double? opacity;
  final bool isTopOnly;

  const SharedContainer({
    super.key,
    required this.child,
    this.borderRadius = 30,
    this.blur,
    this.opacity,
    this.isTopOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final customRadius = isTopOnly
        ? BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          )
        : BorderRadius.circular(borderRadius);

    return ClipRRect(
      borderRadius: customRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur ?? 15, sigmaY: blur ?? 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.blackSoft.withValues(alpha: opacity ?? 0.5),
            borderRadius: customRadius,
            border: Border.all(
              color: AppColors.light600.withValues(alpha: 0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
