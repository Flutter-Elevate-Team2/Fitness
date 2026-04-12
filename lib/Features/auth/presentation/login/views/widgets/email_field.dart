import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const EmailField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (_) => onChanged(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => FormValidators.validateEmail(context, value),
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: context.l10n.email,
        hintStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Image.asset(Assets.images.mail.path, height: 20),
      ),
    );
  }
}
