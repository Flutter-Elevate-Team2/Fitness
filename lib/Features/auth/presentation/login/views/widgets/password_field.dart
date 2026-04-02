import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('passwordField'),
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.dark,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) =>
          FormValidators.validateLoginPassword(context, value),
      obscureText: !_isVisible,
      controller: widget.controller,
      onChanged: (value) {
        widget.onChanged();
      },
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        hintText: context.l10n.password,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white,
          size: 20,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(
            _isVisible
                ? Icons.visibility
                : Icons
                      .visibility_off_outlined, // تغيير شكل الأيقونة لتطابق الصورة
            color: Colors.white70,
            size: 20,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        // أضيفي الـ errorBorder زي ما عملنا فوق في الإيميل
      ),
    );
  }
}
