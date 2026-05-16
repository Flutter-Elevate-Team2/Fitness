import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';

class ResendCodeText extends StatelessWidget {
  final String? email;
  final bool isLoading;

  const ResendCodeText({super.key, this.email, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.didntReceiveCode,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white , fontWeight: FontWeight.normal),
        ),
        isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton(
                onPressed: () {
                  context.read<ForgetPasswordViewModel>().doIntent(
                    SendOtp(email: email ?? ''),
                  );
                },
                child: Text(
                  context.l10n.resendCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
      ],
    );
  }
}
