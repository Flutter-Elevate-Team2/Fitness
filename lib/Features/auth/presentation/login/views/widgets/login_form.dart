import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/email_field.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(String email)? onEmailChanged;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.onEmailChanged,
  });

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
       if (!context.mounted) return;
       final isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        context.goNamed(
          Routes.signupName,
          extra: {
            "step": 1,
            "user": user,
           },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please complete registration first"),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        if (!context.mounted) return;
        context.read<LoginViewModel>().doIntent(
          GoogleLoginEvent(email: user?.email.toString() ?? ""),
        );
       }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google login failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Head text
        Text(
          context.l10n.login,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 16),

        /// Email Field
        EmailField(controller: emailController, onChanged: () {}),
        const SizedBox(height: 16),

        /// Password Field
        PasswordField(controller: passwordController, onChanged: () {}),

        /// Forget Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              /// Navigate to Forget Password
              context.pushNamed(Routes.forgetPasswordName);
            },
            child: Text(
              context.l10n.forgetPassword,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        /// OR Row
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 42),
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.white, height: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  context.l10n.or,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(child: Divider(color: Colors.white, height: 1)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        /// Facebook , google Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(Icons.facebook),
            const SizedBox(width: 20),
            _socialIcon(
              Icons.g_mobiledata,
              onTap: () => signInWithGoogle(context),

            ),
            const SizedBox(width: 20),
            _socialIcon(Icons.apple),
          ],
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
