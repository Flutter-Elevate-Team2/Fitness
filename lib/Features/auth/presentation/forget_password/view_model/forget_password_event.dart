sealed class ForgetPasswordEvent {}

class SendOtp extends ForgetPasswordEvent {
  final String email;
  SendOtp({required this.email});
}

class VerifyOtp extends ForgetPasswordEvent {
  final String otp;
  VerifyOtp({required this.otp});
}

class ResetPassword extends ForgetPasswordEvent {
  final String newPassword;
  final String email;
  ResetPassword({required this.newPassword, required this.email});
}
