import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final bool hasBorder;
  final Color? borderColor;

  const CustomButton({
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.hasBorder = false,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,

            disabledBackgroundColor:
                disabledBackgroundColor ?? AppColors.light400,
            disabledForegroundColor:
                disabledForegroundColor ?? AppColors.white,

            side: hasBorder
                ? BorderSide(color: borderColor ?? AppColors.primary, width: 1)
                : ((!isDisabled && backgroundColor == AppColors.white)
                ? BorderSide(color: AppColors.light400)
                : null),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: (!isDisabled && backgroundColor == AppColors.white)
                  ? AppColors.primary
                  : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
