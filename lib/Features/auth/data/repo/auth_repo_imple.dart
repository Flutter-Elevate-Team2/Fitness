import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
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
class AuthRepoImple with ApiExecutionMixin implements AuthRepoContract {
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;
  final AuthLocalDataSourceContract _localDataSource;

  AuthRepoImple(this._authRemoteDataSourceContract, this._localDataSource);

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
      action: () => _authRemoteDataSourceContract.register(request),
      mapper: (data) {
        if (data.token != null && data.token!.isNotEmpty) {
          _localDataSource.saveToken(data.token!);
        }
        return data.toEntity();
      },
    );
  }
}
