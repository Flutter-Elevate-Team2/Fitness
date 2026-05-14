import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/email_field.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({
    super.key,
    required this.onNextPage,
    this.onEmailSubmitted,
  });

  final VoidCallback onNextPage;
  final void Function(String email)? onEmailSubmitted;

  @override
  State<ForgetPasswordEmailScreen> createState() =>
      _ForgetPasswordEmailScreenBodyState();
}

class _ForgetPasswordEmailScreenBodyState
    extends State<ForgetPasswordEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      widget.onEmailSubmitted?.call(email);

      context.read<ForgetPasswordViewModel>().doIntent(SendOtp(email: email));
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
        final sendOtpState = state.sendOtpState;

        if (sendOtpState?.data != null && sendOtpState?.isLoading == false) {
          widget.onNextPage();
        } else if (sendOtpState?.errorMessage != null &&
            sendOtpState?.isLoading == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(sendOtpState!.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.sendOtpState?.isLoading ?? false;
        return Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: SharedAuthLayout(
            showBackButton: false,
            isGreeting: true,
            title: context.l10n.enterYourEmail,
            subtitle: context.l10n.forgetPassword,
            buttonTitle: context.l10n.sentOtp,
            onButtonPressed: () {
              isLoading ? null : _handleSubmit();
            },
            formBody: EmailField(
              controller: _emailController,
              onChanged: () {},
            ),
          ),
        );
      },
    );
  }
}
