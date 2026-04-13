import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/forget_password_widgets/forget_password_email_screen.dart';
import 'package:flutter/material.dart';
 import 'package:fitness_app/Features/auth/presentation/forget_password/views/screens/reset_password_screen.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/views/screens/verify_reset_password_screen.dart';

class ForgetPasswordPageview extends StatelessWidget {
  const ForgetPasswordPageview({
    super.key,
    required this.pageController,
    required this.onNextPage,
    required this.onPreviousPage,
    this.onEmailSubmitted,
    this.userEmail,
    this.otpErrorMessage,
  });

  final PageController pageController;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final void Function(String email)? onEmailSubmitted;
  final String? userEmail;
  final String? otpErrorMessage;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ForgetPasswordEmailScreen(
          onNextPage: onNextPage,
          onEmailSubmitted: onEmailSubmitted,
        ),
        VerifyResetPasswordScreen(
          email: userEmail,
          onPreviousPage: onPreviousPage,
          onNextPage: onNextPage,
          errorMessage: otpErrorMessage,
        ),
        ResetPasswordScreen(
          onPreviousPage: onPreviousPage,
          userEmail: userEmail,
        ),
      ],
    );
  }
}
