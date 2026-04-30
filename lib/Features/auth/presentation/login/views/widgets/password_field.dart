import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final String? title;
  const PasswordField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.title
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (_) => widget.onChanged(),
      obscureText: !_isVisible,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) =>
          FormValidators.validateLoginPassword(context, value),
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: widget.title ?? context.l10n.password,
        hintStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Image.asset(Assets.images.lock.path, height: 20),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isVisible = !_isVisible),
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off_outlined,
            size: 20,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
