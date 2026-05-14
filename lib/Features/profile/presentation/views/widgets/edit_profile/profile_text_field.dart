import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CustomProfileField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showEditHint;
  final Color? fillColor;

  const CustomProfileField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.showEditHint = false,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged != null ? (_) => onChanged!() : null,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: fillColor != null,
        fillColor: fillColor,
      ),
    );
  }
}
