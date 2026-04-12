import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
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
      controller: widget.controller,
      onChanged: (_) => widget.onChanged(),
      obscureText: !_isVisible,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) =>
          FormValidators.validateLoginPassword(context, value),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: context.l10n.password,
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isVisible = !_isVisible),
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off_outlined,
            size: 20,
          ),
        ),
      ),
    );
  }
}
