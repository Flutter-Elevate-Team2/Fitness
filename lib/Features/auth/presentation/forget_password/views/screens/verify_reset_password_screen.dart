import 'package:flutter/material.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/verify_reset_password_screen_body.dart';

class VerifyResetPasswordScreen extends StatelessWidget {
  const VerifyResetPasswordScreen({
    super.key,
    required this.onPreviousPage,
    required this.onNextPage,
    this.email,
    this.errorMessage,
  });

  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final String? email;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return   VerifyResetPasswordScreenBody(onNextPage: onNextPage, email: email,);
  }
}
