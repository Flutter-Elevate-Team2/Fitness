import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_login_row.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/form_validators.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/pill_text_form_field.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupFirstStep extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onNextStep;

  const SignupFirstStep({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.onNextStep,
  });

  @override
  State<SignupFirstStep> createState() => _SignupFirstStepState();
}

class _SignupFirstStepState extends State<SignupFirstStep> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      title: context.l10n.heyThere,

      subtitle: context.l10n.createAccount,
      showBackButton: false,
      isGreeting: true,
      buttonTitle: context.l10n.registerNow,
      onButtonPressed: () async {
        if (_formKey.currentState!.validate()) {

          final email = widget.emailController.text.trim();
          final password = widget.passwordController.text.trim();

          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            print("Signup success");

            // بعد النجاح روحي للخطوة اللي بعدها
            widget.onNextStep();

          } catch (e) {
            debugPrint("Signup error: $e");
          }
        }
      },
      formBody: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ── "Register" Heading ──
          Text(
            context.l10n.registerNow,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.white,
                ),
          ),
          const SizedBox(height: 20),

          /// ── Form Fields ──
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ── First Name ──
                PillTextFormField(
                  controller: widget.firstNameController,
                  hintText: context.l10n.firstName,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    context.l10n.firstName,
                  ),
                ),
                const SizedBox(height: 14),

                /// ── Last Name ──
                PillTextFormField(
                  controller: widget.lastNameController,
                  hintText: context.l10n.lastName,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    context.l10n.lastName,
                  ),
                ),
                const SizedBox(height: 14),

                /// ── Email ──
                PillTextFormField(
                  controller: widget.emailController,
                  hintText: context.l10n.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) =>
                      FormValidators.validateEmail(context, value),
                ),
                const SizedBox(height: 14),

                /// ── Password ──
                PillTextFormField(
                  controller: widget.passwordController,
                  hintText: context.l10n.password,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  validator: (value) =>
                      FormValidators.validatePassword(context, value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// ── Social Login ──
          SocialLoginRow(
            onGoogleSuccess: (email, firstName, lastName , password) {
              widget.emailController.text = email;
              widget.firstNameController.text = firstName;
              widget.lastNameController.text = lastName;
              widget.passwordController.text = password;
            },
          ),
        ],
      ),

      /// ── Already Have An Account? Login ──
      underButtonWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.alreadyHaveAccount,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.light600,
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => context.goNamed(Routes.loginName),
            child: Text(
              context.l10n.login,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
