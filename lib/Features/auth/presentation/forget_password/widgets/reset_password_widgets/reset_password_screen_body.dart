import 'package:fitness_app/Features/auth/presentation/login/views/widgets/password_field.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';

class ResetPasswordScreenBody extends StatefulWidget {
  const ResetPasswordScreenBody({super.key, this.userEmail});

  final String? userEmail;

  @override
  State<ResetPasswordScreenBody> createState() =>
      _ResetPasswordScreenBodyState();
}

class _ResetPasswordScreenBodyState extends State<ResetPasswordScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = widget.userEmail ?? '';
      if (widget.userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.emailRequired),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }
      if (_newPassword.text.trim() != _confirmPassword.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.passwordMismatch)
            ,
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }
      context.read<ForgetPasswordViewModel>().doIntent(
        ResetPassword(newPassword: _newPassword.text.trim(), email: email),
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        final resetPasswordState = state.resetPasswordState;

        if (resetPasswordState?.data != null &&
            resetPasswordState?.isLoading == false) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: SharedContainer(
                borderRadius: 24,
                blur: 20,
                opacity: 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.success,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.resetSuccessfully,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: context.l10n.done,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (resetPasswordState?.errorMessage != null &&
            resetPasswordState?.isLoading == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resetPasswordState!.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.resetPasswordState?.isLoading ?? false;

        return SharedAuthLayout(
          showBackButton: false,
          isGreeting: true,
          title: context.l10n.passwordLengthNote,
          subtitle: context.l10n.createNewPassword,
          buttonTitle: context.l10n.done,
          onButtonPressed: () {
            isLoading ? null : _handleSubmit();
          },
          formBody: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              children: [
                PasswordField(
                  controller: _newPassword,
                  onChanged: () {},
                  key: const Key('new_password_field'),
                ),
                const SizedBox(height: 24),
                PasswordField(
                  key: const Key('confirm_password_field'),
                  controller: _confirmPassword,
                  onChanged: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
