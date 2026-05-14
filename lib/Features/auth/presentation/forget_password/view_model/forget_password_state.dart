import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<ForgetPasswordEntity>? sendOtpState;
  final BaseState<VerifyResetPasswordEntity>? verifyOtpState;
  final BaseState<ResetPasswordEntity>? resetPasswordState;

  const ForgetPasswordState({
    this.sendOtpState,
    this.verifyOtpState,
    this.resetPasswordState,
  });

  ForgetPasswordState copyWith({
    BaseState<ForgetPasswordEntity>? sendOtpState,
    BaseState<VerifyResetPasswordEntity>? verifyOtpState,
    BaseState<ResetPasswordEntity>? resetPasswordState,
  }) {
    return ForgetPasswordState(
      sendOtpState: sendOtpState ?? this.sendOtpState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }

  @override
  List<Object?> get props => [sendOtpState, verifyOtpState, resetPasswordState];
}
