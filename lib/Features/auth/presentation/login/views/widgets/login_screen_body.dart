import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_form.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

    return SharedAuthLayout(
      showBackButton: false,
      isGreeting: true,
      title: context.l10n.heyThere,
      subtitle: context.l10n.welcomeBack,
      buttonTitle: context.l10n.login,
      onButtonPressed: () {
        // هنا هتحتاجي تجمعي البيانات من الـ Form
        // viewModel.doIntent(LoginButtonClickedEvent(email: ..., password: ...));
        // viewModel.doIntent(LoginButtonClickedEvent(
        //   email: _emailController.text,
        //   password: _passwordController.text,
        // ));
      },
      formBody: const LoginForm(),
      underButtonWidget: Center(
        child: TextButton(
          onPressed: () => print("Navigate to Register"),
          child: Text(
            context.l10n.dontHaveAccount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
