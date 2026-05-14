import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/otp_input_widget.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/resend_code_text.dart';
import 'package:fitness_app/core/extension/context_extention.dart';

class VerifyResetPasswordScreenBody extends StatelessWidget {
  const VerifyResetPasswordScreenBody({
    super.key,
    required this.onNextPage,
    this.email,
    this.errorMessage,
  });

  final VoidCallback onNextPage;
  final String? email;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    String? otp;
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        if (state.verifyOtpState?.data != null &&
            state.verifyOtpState?.isLoading == false) {
          onNextPage();
        }
      },
      builder: (context, state) {
        final isVerifyLoading = state.verifyOtpState?.isLoading ?? false;
        final isResendLoading = state.sendOtpState?.isLoading ?? false;

        return SharedAuthLayout(
          showBackButton: false,
          isGreeting: true,
          title: context.l10n.enterYourOtp,
          subtitle: context.l10n.otpCode,
          buttonTitle: context.l10n.confirm,
          onButtonPressed: () {
            if (otp != null && otp!.length == 6) {
              context.read<ForgetPasswordViewModel>().doIntent(
                VerifyOtp(otp: otp!),
              );
            }
          },
          formBody: OtpInputWidget(
            length: 6,
            errorText: state.verifyOtpState?.errorMessage,
            onCompleted: (value) {
              otp = value;
            },
          ),
          underButtonWidget: (isVerifyLoading)
              ? const CircularProgressIndicator()
              : ResendCodeText(email: email, isLoading: isResendLoading),
        );
      },
    );
  }
}
