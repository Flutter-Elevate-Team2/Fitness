import 'package:fitness_app/Features/auth/api/api_client/auth_api.dart';
import 'package:fitness_app/Features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImple implements AuthRemoteDataSourceContract {
  final AuthApi _authApi;

  AuthRemoteDataSourceImple(this._authApi);

  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return _authApi.register(request);
  }
}
