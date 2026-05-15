import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/core/interceptors/auth_interceptors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_interceptors_test.mocks.dart';

@GenerateMocks([
  FlutterSecureStorage,
  SessionController,
  RequestInterceptorHandler,
  ErrorInterceptorHandler,
])
void main() {
  late AuthInterceptor authInterceptor;
  late MockFlutterSecureStorage mockStorage;
  late MockSessionController mockSessionController;
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.instance;
    mockStorage = MockFlutterSecureStorage();
    mockSessionController = MockSessionController();

    if (!getIt.isRegistered<SessionController>()) {
      getIt.registerSingleton<SessionController>(mockSessionController);
    }

    authInterceptor = AuthInterceptor(mockStorage);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('AuthInterceptor onRequest', () {
    test('should NOT add Authorization header for public paths', () async {
      final options = RequestOptions(path: ApiConstants.login);
      final handler = MockRequestInterceptorHandler();

      authInterceptor.onRequest(options, handler);

      expect(options.headers["Authorization"], isNull);
      verify(handler.next(options)).called(1);
    });

    test(
      'should add Authorization header if token exists for private paths',
      () async {
        final options = RequestOptions(path: '/user/profile');
        final handler = MockRequestInterceptorHandler();

        when(
          mockStorage.read(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async => 'fake_token');

        await (authInterceptor.onRequest(options, handler) as dynamic);

        expect(options.headers["Authorization"], "Bearer fake_token");
        verify(handler.next(options)).called(1);
      },
    );

    test('should NOT add Authorization header if token is empty', () async {
      final options = RequestOptions(path: '/user/profile');
      final handler = MockRequestInterceptorHandler();
      when(
        mockStorage.read(key: ApiConstants.tokenKey),
      ).thenAnswer((_) async => '');

      authInterceptor.onRequest(options, handler);

      expect(options.headers["Authorization"], isNull);
    });
  });

  group('AuthInterceptor onError', () {
    test('should logout when receiving 401 on private path', () async {
      final requestOptions = RequestOptions(path: '/user/profile');
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      await (authInterceptor.onError(err, handler) as dynamic);

      verify(mockStorage.delete(key: ApiConstants.tokenKey)).called(1);
      verify(mockSessionController.expireSession()).called(1);
      verify(handler.next(err)).called(1);
    });

    test('should NOT logout when receiving 401 on public path', () async {
      final requestOptions = RequestOptions(path: ApiConstants.login);
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      authInterceptor.onError(err, handler);

      verifyNever(mockStorage.delete(key: anyNamed('key')));
      verifyNever(mockSessionController.expireSession());
      verify(handler.next(err)).called(1);
    });

    test('should NOT logout when receiving 401 on public path', () async {
      final requestOptions = RequestOptions(path: ApiConstants.login);
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      authInterceptor.onError(err, handler);

      verifyNever(mockStorage.delete(key: anyNamed('key')));
      verifyNever(mockSessionController.expireSession());
      verify(handler.next(err)).called(1);
    });

    test('should handle logout flag to prevent concurrent logouts', () async {
      final requestOptions = RequestOptions(path: '/user/profile');
      final response = Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      authInterceptor.onError(err, handler);
      expect(authInterceptor.runtimeType, AuthInterceptor);
    });
  });
}
