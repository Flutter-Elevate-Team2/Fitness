import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class PillTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const PillTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
  });

  static OutlineInputBorder _pillBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeDecoration = Theme.of(context).inputDecorationTheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: themeDecoration.prefixIconColor,
        suffixIcon: suffixIcon,
        suffixIconColor: themeDecoration.suffixIconColor,
        filled: false,
        contentPadding: themeDecoration.contentPadding,

        enabledBorder: _pillBorder(AppColors.white),
        focusedBorder: _pillBorder(AppColors.primary, width: 1.5),
        errorBorder: _pillBorder(AppColors.red),
        focusedErrorBorder: _pillBorder(AppColors.red, width: 1.5),
        errorStyle: const TextStyle(color: AppColors.red),
      ),
    );
  }
}
