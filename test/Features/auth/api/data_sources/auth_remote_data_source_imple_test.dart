import 'package:fitness_app/Features/auth/api/api_client/auth_api.dart';
import 'package:fitness_app/Features/auth/api/data_sources/auth_remote_data_source_imple.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_remote_data_source_imple_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApi mockAuthApi;

  setUp(() {
    mockAuthApi = MockAuthApi();
    dataSource = AuthRemoteDataSourceImpl(mockAuthApi);
  });

  // ================= LOGIN =================
  group('login', () {
    final tRequest = LoginRequest(email: 'test@test.com', password: '123456');

    final tResponse = LoginResponse(message: 'Success', token: 'token');

    test('should return LoginResponse when AuthApi.login succeeds', () async {
      // arrange
      when(mockAuthApi.login(tRequest)).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.login(tRequest);

      // assert
      expect(result, tResponse);
      verify(mockAuthApi.login(tRequest)).called(1);
    });

    test('should throw Exception when AuthApi.login fails', () async {
      // arrange
      when(mockAuthApi.login(any)).thenThrow(Exception('Login Failed'));

      // act & assert
      expect(() => dataSource.login(tRequest), throwsException);
    });
  });

}
