import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';

abstract class AuthRemoteDataSourceContract {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<ForgetPasswordResponse> forgetPassword(ForgetPasswordRequest request);
  Future<VerifyResetPasswordResponse> verifyPassword(
    VerifyResetPasswordRequest request,
  );
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request);
}
