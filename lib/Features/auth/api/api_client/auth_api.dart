import 'package:dio/dio.dart';
import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'auth_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  /// === Login Endpoint ===
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// === Forget Password Endpoints ===
  @POST(ApiConstants.forgetPassword)
  Future<ForgetPasswordResponse> forgetPassword(
      @Body() ForgetPasswordRequest forgetRequest,
      );

  @POST(ApiConstants.verifyResetCode)
  Future<VerifyResetPasswordResponse> verifyPassword(
      @Body() VerifyResetPasswordRequest verifyRequest,
      );

  @PUT(ApiConstants.resetPassword)
  Future<ResetPasswordResponse> resetPassword(
      @Body() ResetPasswordRequest resetRequest,
      );
  @POST(ApiConstants.signup)
  Future<RegisterResponse> register(@Body() RegisterRequest request);
}
