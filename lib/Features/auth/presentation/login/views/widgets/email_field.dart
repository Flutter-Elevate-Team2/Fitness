import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: TextFormField(
        key: Key('emailField'),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => FormValidators.validateEmail(context, value),
        controller: controller,
        onChanged: (_) => onChanged(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          hintText: context.l10n.email,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: Colors.white,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white30), // خط خفيف جداً
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.white,
            ), // يظهر بوضوح عند الضغط
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
