import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_screen_body.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.onPreviousPage,
    this.userEmail,
  });

  final VoidCallback onPreviousPage;
  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    return  ResetPasswordScreenBody(userEmail: userEmail);
  }
}
