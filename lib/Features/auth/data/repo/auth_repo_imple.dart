import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/mappers/login_mapper/login_mapper.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
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

  @override
  Future<BaseResponse<LoginEntity>> login(
    LoginRequest request,
    bool isRememberMe,
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
        await _localDataSource.saveRememberMe(isRememberMe);
      }
    }
    return result;
  }

  @override
  Future<bool> isLoggedIn() async {
    if (_isCurrentSessionActive) return true;

    final token = await _localDataSource.getToken();
    final isRememberMe = await _localDataSource.getRememberMe();

    if (token != null && token.isNotEmpty) {
      if (isRememberMe) {
        _isCurrentSessionActive = true;
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  void clearSession() {
    _isCurrentSessionActive = false;
  }
}
