import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/forget_password_use_cases/forget_password_use_case.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/forget_password_use_cases/reset_password_use_case.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/forget_password_use_cases/verify_reset_password_use_case.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

@injectable
class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyResetPasswordUseCase _verifyPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgetPasswordViewModel(
    this._forgetPasswordUseCase,
    this._verifyPasswordUseCase,
    this._resetPasswordUseCase,
  ) : super(ForgetPasswordState());

  Future<void> doIntent(ForgetPasswordEvent event) async {
    switch (event) {
      case SendOtp():
        await _handleSendOtp(event);
        break;
      case VerifyOtp():
        await _handleVerifyOtp(event);
        break;
      case ResetPassword():
        await _handleResetPassword(event);
        break;
    }
  }

  Future<void> _handleSendOtp(SendOtp intent) async {
    emit(
      state.copyWith(
        sendOtpState: BaseState<ForgetPasswordEntity>(isLoading: true),
      ),
    );

    final request = ForgetPasswordRequest(email: intent.email);

    final response = await _forgetPasswordUseCase.forgetPassword(request);

    switch (response) {
      case SuccessResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            sendOtpState: BaseState(isLoading: false, data: response.data),
          ),
        );
        break;

      case ErrorResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            sendOtpState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _handleVerifyOtp(VerifyOtp intent) async {
    emit(
      state.copyWith(
        verifyOtpState: BaseState<VerifyResetPasswordEntity>(isLoading: true),
      ),
    );

    final request = VerifyResetPasswordRequest(resetCode: intent.otp);

    final response = await _verifyPasswordUseCase.verifyPassword(request);

    switch (response) {
      case SuccessResponse<VerifyResetPasswordEntity>():
        emit(
          state.copyWith(
            verifyOtpState: BaseState(isLoading: false, data: response.data),
          ),
        );
        break;

      case ErrorResponse<VerifyResetPasswordEntity>():
        emit(
          state.copyWith(
            verifyOtpState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _handleResetPassword(ResetPassword intent) async {
    emit(
      state.copyWith(
        resetPasswordState: BaseState<ResetPasswordEntity>(isLoading: true),
      ),
    );

    final request = ResetPasswordRequest(
      newPassword: intent.newPassword,
      email: intent.email,
    );

    final response = await _resetPasswordUseCase.resetPassword(request);

    switch (response) {
      case SuccessResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordState: BaseState(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
        break;

      case ErrorResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
