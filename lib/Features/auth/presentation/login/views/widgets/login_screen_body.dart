import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_form.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? userEmail;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    _passwordController.removeListener(_updateButtonState);
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();
    return SharedAuthLayout(
      showBackButton: false,
      isGreeting: true,
      title: context.l10n.heyThere,
      subtitle: context.l10n.welcomeBack,
      buttonTitle: context.l10n.login,
      onButtonPressed: _isButtonEnabled
          ? () {
              if (_formKey.currentState!.validate()) {
                viewModel.doIntent(
                  LoginButtonClickedEvent(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              } else {
                setState(() {
                  _autoValidateMode = AutovalidateMode.always;
                });
              }
            }
          : null,
      formBody: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: LoginForm(
          emailController: _emailController,
          passwordController: _passwordController,
          onEmailChanged: (email) {
            setState(() {
              userEmail = email;
            });
          },
        ),
      ),
      underButtonWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.dontHaveAccount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              /// Navigate to Register
              context.pushNamed(Routes.signupName);
            },
            child: Text(
              context.l10n.registerNow,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
