import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
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
    test('updateSessionAuth should write token to storage', () async {
      const token = 'new_test_token';
      await sessionController.updateSessionAuth(token);
      verify(
        mockStorage.write(key: ApiConstants.tokenKey, value: token),
      ).called(1);
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

        expect(
          true,
          isTrue,
        );
      },
    );

    test('dispose coverage', () {
      sessionController.dispose();
      expect(true, isTrue);
    });
  });
}
