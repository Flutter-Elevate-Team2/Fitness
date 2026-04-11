import 'package:fitness_app/Features/auth/data/models/register_request/register_request.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';

abstract class AuthRemoteDataSourceContract {
  Future<RegisterResponse> register(RegisterRequest request);
}
