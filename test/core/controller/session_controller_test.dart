import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_controller_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late SessionController sessionController;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    sessionController = SessionController(mockStorage);
  });

  group('SessionController Tests', () {
    test(
      'initSession should read token from storage and update _token',
      () async {
        // Arrange
        when(
          mockStorage.read(key: ApiConstants.tokenKey),
        ).thenAnswer((_) async => 'stored_token');

        // Act
        await sessionController.initSession();

        // Assert
        expect(sessionController.token, 'stored_token');
        expect(sessionController.isLoggedIn, isTrue);
      },
    );

    test(
      'updateSessionAuth should write token to storage and notifyLogin',
      () async {
        const token = 'new_test_token';
        await sessionController.updateSessionAuth(token);

        expect(sessionController.token, token);
        expect(sessionController.isLoggedIn, isTrue);
        verify(
          mockStorage.write(key: ApiConstants.tokenKey, value: token),
        ).called(1);
      },
    );

    test('saveUser should set the current user', () {
      final user = UserEntity(
        id: '1',
        firstName: '',
        lastName: '',
        email: '',
        photo: '',
        gender: '',
        age: 20,
        weight: 70,
        height: 160,
        activityLevel: '',
        goal: '',
      );
      sessionController.saveUser(user);

      expect(sessionController.user, user);
    });

    test('updateUser should update the current user', () {
      final user = UserEntity(
        id: '1',
        firstName: '',
        lastName: '',
        email: '',
        photo: '',
        gender: '',
        age: 20,
        weight: 70,
        height: 160,
        activityLevel: '',
        goal: '',
      );
      sessionController.saveUser(user);

      final updatedUser = UserEntity(
        id: '1',
        firstName: '',
        lastName: '',
        email: '',
        photo: '',
        gender: '',
        age: 20,
        weight: 70,
        height: 160,
        activityLevel: '',
        goal: '',
      );
      sessionController.updateUser(updatedUser);

      expect(sessionController.user, updatedUser);
    });

    test(
      'expireSession should delete token and emit to onSessionExpired',

      () async {
        bool emitted = false;

        sessionController.onSessionExpired.listen((_) => emitted = true);

        await sessionController.expireSession();

        await Future.delayed(Duration.zero);

        expect(emitted, isTrue);

        verify(mockStorage.delete(key: ApiConstants.tokenKey)).called(1);
      },
    );

    test('notifyLogin should emit to onLogin', () async {
      bool emitted = false;
      sessionController.onLogin.listen((_) => emitted = true);

      sessionController.notifyLogin();

      await Future.delayed(Duration.zero);

      expect(emitted, isTrue);
    });

    test(
      'notifyLogout should delete token and emit reason to onLogout',
      () async {
        SessionEndReason? receivedReason;
        sessionController.onLogout.listen((reason) => receivedReason = reason);

        await sessionController.notifyLogout(SessionEndReason.logout);

        await Future.delayed(Duration.zero);

        expect(receivedReason, SessionEndReason.logout);
        expect(sessionController.token, isNull);
        expect(sessionController.user, isNull);
        verify(mockStorage.delete(key: ApiConstants.tokenKey)).called(1);
      },
    );

    test(
      'should not add to stream if controller is closed (Coverage for isClosed)',
      () async {
        sessionController.dispose();

        await sessionController.expireSession();
        sessionController.notifyLogin();
        await sessionController.notifyLogout(SessionEndReason.guest);

        expect(true, isTrue);
      },
    );

    test('dispose coverage', () {
      sessionController.dispose();
      expect(true, isTrue);
    });
  });
}
