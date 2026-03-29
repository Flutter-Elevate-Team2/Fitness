import 'dart:ui';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SharedContainer extends StatelessWidget {
  final Widget child;

  const SharedContainer({
    super.key,
    required this.child,
    }) : super();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 34.6, sigmaY: 34.6),
        child: Container(
          padding: EdgeInsetsGeometry.all(24),
          decoration: BoxDecoration(
            color: AppColors.blackSoft,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.light600), // optional border
          ),
          child: child,
        ),
      ),
    );
  }
}