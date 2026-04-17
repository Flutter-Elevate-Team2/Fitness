import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/mappers/forget_password_mappers/forget_password_mapper.dart';
import 'package:fitness_app/Features/auth/data/mappers/forget_password_mappers/reset_password_mapper.dart';
import 'package:fitness_app/Features/auth/data/mappers/forget_password_mappers/verify_reset_password_mapper.dart';
import 'package:fitness_app/Features/auth/data/mappers/login_mapper/login_mapper.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
import 'package:fitness_app/Features/auth/data/mappers/register_mappers.dart';
import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/helpers/api_execution_mixin.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepoContract)
class AuthRepoImpl with ApiExecutionMixin implements AuthRepoContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSourceContract _localDataSource;

  bool _isCurrentSessionActive = false;

  AuthRepoImpl(this._remoteDataSource, this._localDataSource);

  /// Register
  @override
  Future<BaseResponse<UserEntity>> register(RegisterParams params) {
    final request = RegisterRequest(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      rePassword: params.password,
      gender: params.gender,
      age: params.age,
      weight: params.weight,
      height: params.height,
      activityLevel: params.activityLevel,
      goal: params.goal,
    );
    return execute<RegisterResponse, UserEntity>(
      action: () => _remoteDataSource.register(request),
      mapper: (data) {
        if (data.token != null && data.token!.isNotEmpty) {
          _localDataSource.saveToken(data.token!);
        }
        return data.toEntity();
      },
    );
  }

  /// Login
  @override
  Future<BaseResponse<LoginEntity>> login(
    LoginRequest request
  ) async {
    final result = await execute<LoginResponse, LoginEntity>(
      action: () async => await _remoteDataSource.login(request),
      mapper: (response) => response.toEntity(),
    );

    if (result is SuccessResponse<LoginEntity>) {
      final token = result.data.token;
      if (token != null && token.isNotEmpty) {
        _isCurrentSessionActive = true;
        await _localDataSource.saveToken(token);
      }
    }
    return result;
  }

  @override
  Future<bool> isLoggedIn() async {
    if (_isCurrentSessionActive) return true;

    final token = await _localDataSource.getToken();

    if (token != null && token.isNotEmpty) {
      _isCurrentSessionActive = true;
      return true;
    }
    return false;
  }

  @override
  void clearSession() {
    _isCurrentSessionActive = false;
  }

  /// --- Forget Password ---
  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    return execute<ForgetPasswordResponse, ForgetPasswordEntity>(
      action: () async => await _remoteDataSource.forgetPassword(request),
      mapper: (response) => response.toEntity(),
    );
  }

  /// --- Verify Reset Password ---
  @override
  Future<BaseResponse<VerifyResetPasswordEntity>> verifyPassword(
    VerifyResetPasswordRequest request,
  ) async {
    return execute<VerifyResetPasswordResponse, VerifyResetPasswordEntity>(
      action: () async => await _remoteDataSource.verifyPassword(request),
      mapper: (response) => response.toEntity(),
    );
  }

  /// --- Reset Password ---
  @override
  Future<BaseResponse<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    return execute<ResetPasswordResponse, ResetPasswordEntity>(
      action: () async => await _remoteDataSource.resetPassword(request),
      mapper: (response) => response.toEntity(),
    );
  }
}
