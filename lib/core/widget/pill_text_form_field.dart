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

  /// Creates a pill-shaped [OutlineInputBorder] with the given [color] and
  /// [width]. Extracted as a helper to avoid repeating the same border
  /// construction four times (DRY).
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
          ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: themeDecoration.hintStyle,
        prefixIcon: prefixIcon,
        prefixIconColor: themeDecoration.prefixIconColor,
        suffixIcon: suffixIcon,
        suffixIconColor: themeDecoration.suffixIconColor,
        filled: false,
        contentPadding: themeDecoration.contentPadding,

        /// Only the borders and their colors differ from the global theme
        /// (pill radius 100 + white enabled border vs. the theme's radius 12).
        enabledBorder: _pillBorder(AppColors.white),
        focusedBorder: _pillBorder(AppColors.primary, width: 1.5),
        errorBorder: _pillBorder(AppColors.red),
        focusedErrorBorder: _pillBorder(AppColors.red, width: 1.5),
        errorStyle: const TextStyle(color: AppColors.red),
      ),
    );
  }
}
