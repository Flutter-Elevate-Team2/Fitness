import 'package:fitness_app/Features/auth/presentation/login/views/widgets/email_field.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        EmailField(controller: _emailController, onChanged: () {}),

        /// Password Field
        PasswordField(controller: _passwordController, onChanged: () {}),
        const SizedBox(height: 16),

        /// Forget Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              context.l10n.forgetPassword,
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),

        /// OR Row
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white30)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(context.l10n.or, style: TextStyle(color: Colors.white)),
            ),
            Expanded(child: Divider(color: Colors.white30)),
          ],
        ),
        const SizedBox(height: 16),

        /// Facebook , google Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(Icons.facebook as String),
            const SizedBox(width: 20),
            _socialIcon(Icons.g_mobiledata as String),
            const SizedBox(width: 20),
            _socialIcon(Icons.apple as String),
          ],
        ),
      ],
    );
  }
  Widget _socialIcon(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
