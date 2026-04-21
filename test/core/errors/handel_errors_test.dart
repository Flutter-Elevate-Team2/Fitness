import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/errors/error_strings.dart';
import 'package:fitness_app/core/errors/handel_errors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  group('ErrorHandler Tests', () {
    test('should handle SocketException', () {
      final result = ErrorHandler.handleError(
        const SocketException('no internet'),
      );
      expect(result, ErrorStrings.noInternet);
    });

    test('should handle HandshakeException', () {
      final result = ErrorHandler.handleError(const HandshakeException());
      expect(result, ErrorStrings.badCertificate);
    });

    test('should handle TimeoutException', () {
      final result = ErrorHandler.handleError(TimeoutException('timeout'));
      expect(result, ErrorStrings.connectionTimeout);
    });

    test('should handle TypeError (Parsing Error)', () {
      final result = ErrorHandler.handleError(TypeError());
      expect(result, ErrorStrings.parsingError);
    });

    test('should handle FormatException', () {
      final result = ErrorHandler.handleError(const FormatException());
      expect(result, ErrorStrings.formatException);
    });

    test('should handle HiveError', () {
      final result = ErrorHandler.handleError(HiveError('hive error'));
      expect(result, ErrorStrings.hiveError);
    });

    test('should handle PlatformException', () {
      final result = ErrorHandler.handleError(
        PlatformException(code: 'network_error'),
      );
      expect(result, ErrorStrings.noInternet);

      final result2 = ErrorHandler.handleError(
        PlatformException(code: 'other'),
      );
      expect(result2, ErrorStrings.platformError);
    });

    test('should handle unknown Error types', () {
      final result = ErrorHandler.handleError('Random String Error');
      expect(result, ErrorStrings.unknownError);
    });

    group('DioException Handling', () {
      test('should handle DioException Types', () {
        expect(
          ErrorHandler.handleError(
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(),
            ),
          ),
          ErrorStrings.connectionTimeout,
        );
        expect(
          ErrorHandler.handleError(
            DioException(
              type: DioExceptionType.sendTimeout,
              requestOptions: RequestOptions(),
            ),
          ),
          ErrorStrings.sendTimeout,
        );
        expect(
          ErrorHandler.handleError(
            DioException(
              type: DioExceptionType.receiveTimeout,
              requestOptions: RequestOptions(),
            ),
          ),
          ErrorStrings.receiveTimeout,
        );
        expect(
          ErrorHandler.handleError(
            DioException(
              type: DioExceptionType.cancel,
              requestOptions: RequestOptions(),
            ),
          ),
          ErrorStrings.requestCancelled,
        );
        expect(
          ErrorHandler.handleError(
            DioException(
              type: DioExceptionType.connectionError,
              requestOptions: RequestOptions(),
            ),
          ),
          ErrorStrings.connectionError,
        );
        expect(
          ErrorHandler.handleError(
            DioException(
              type: DioExceptionType.badCertificate,
              requestOptions: RequestOptions(),
            ),
          ),
          ErrorStrings.badCertificate,
        );
      });

      test(
        'should handle DioExceptionType.unknown with inner SocketException',
        () {
          final dioError = DioException(
            type: DioExceptionType.unknown,
            error: const SocketException(''),
            requestOptions: RequestOptions(),
          );
          expect(ErrorHandler.handleError(dioError), ErrorStrings.noInternet);
        },
      );

      test(
        'should handle DioExceptionType.unknown with inner HandshakeException',
        () {
          final dioError = DioException(
            type: DioExceptionType.unknown,
            error: const HandshakeException(),
            requestOptions: RequestOptions(),
          );
          expect(
            ErrorHandler.handleError(dioError),
            ErrorStrings.badCertificate,
          );
        },
      );

      test(
        'should handle DioExceptionType.unknown with SocketException message',
        () {
          final dioError = DioException(
            type: DioExceptionType.unknown,
            message: 'SocketException: connection failed',
            requestOptions: RequestOptions(),
          );
          expect(ErrorHandler.handleError(dioError), ErrorStrings.noInternet);
        },
      );

      test('should return networkError for generic unknown DioException', () {
        final dioError = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
        );
        expect(ErrorHandler.handleError(dioError), ErrorStrings.networkError);
      });
    });

    group('Dio Bad Response (Status Codes)', () {
      DioException createDioError(int statusCode, {dynamic data}) {
        return DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: statusCode,
            data: data,
          ),
          requestOptions: RequestOptions(),
        );
      }

      test('should handle 400 and extract message', () {
        final err = createDioError(
          400,
          data: {'message': 'Custom Bad Request'},
        );
        expect(ErrorHandler.handleError(err), 'Custom Bad Request');
      });

      test('should handle 401 and extract error field', () {
        final err = createDioError(401, data: {'error': 'Unauthorized user'});
        expect(ErrorHandler.handleError(err), 'Unauthorized user');
      });

      test('should handle 403, 500, 503', () {
        expect(
          ErrorHandler.handleError(createDioError(403)),
          ErrorStrings.forbidden,
        );
        expect(
          ErrorHandler.handleError(createDioError(500)),
          ErrorStrings.internalServerError,
        );
        expect(
          ErrorHandler.handleError(createDioError(503)),
          ErrorStrings.serviceUnavailable,
        );
      });

      test('should handle 404, 409 and default error', () {
        expect(
          ErrorHandler.handleError(createDioError(404)),
          ErrorStrings.notFound,
        );
        expect(
          ErrorHandler.handleError(createDioError(409)),
          ErrorStrings.conflict,
        );
        expect(
          ErrorHandler.handleError(createDioError(405)),
          ErrorStrings.defaultError,
        );
      });

      test('should handle bad response with non-map data (Catch block)', () {
        final err = createDioError(400, data: "Just a string");
        expect(ErrorHandler.handleError(err), ErrorStrings.badRequest);
      });
    });

    test('should log StackTrace if error is an instance of Error', () {
      final error = ArgumentError('test error');
      final result = ErrorHandler.handleError(error);
      expect(result, ErrorStrings.unknownError);
    });
  });
}
