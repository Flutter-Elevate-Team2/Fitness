import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/chang_password_use_case.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/controller/session_controller.dart';

@GenerateMocks([ChangPasswordUseCase, SessionController])
import 'change_password_view_model_test.mocks.dart';

void main() {
  late ChangePasswordViewModel viewModel;
  late MockChangPasswordUseCase mockUseCase;
  late MockSessionController mockSessionController;

  setUp(() {
    mockUseCase = MockChangPasswordUseCase();
    mockSessionController = MockSessionController();

    provideDummy<BaseResponse<ChangePasswordEntity>>(
      ErrorResponse(errorMessage: ''),
    );

    viewModel = ChangePasswordViewModel(mockUseCase, mockSessionController);
  });

  tearDown(() {
    viewModel.close();
  });

  group('ChangePasswordViewModel', () {
    final request = ChangePasswordRequest(
      password: 'oldPass123',
      newPassword: 'newPass456',
    );

    const entity = ChangePasswordEntity(
      message: 'Password changed successfully',
      token: 'new_token_abc',
    );

    test(
      'emits loading then success state when change password succeeds',
      () async {
        when(
          mockUseCase(request),
        ).thenAnswer((_) async => SuccessResponse(data: entity));
        when(
          mockSessionController.updateSessionAuth('new_token_abc'),
        ).thenAnswer((_) async {});

        final states = <ChangePasswordStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(ChangePasswordEvent(request: request));
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, 2);
        expect(states[0].changePasswordState?.isLoading, true);
        expect(states[1].changePasswordState?.isLoading, false);
        expect(
          states[1].changePasswordState?.data?.message,
          'Password changed successfully',
        );

        await subscription.cancel();
      },
    );

    test('emits loading then error state when change password fails', () async {
      when(
        mockUseCase(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Wrong password'));

      final states = <ChangePasswordStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(ChangePasswordEvent(request: request));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0].changePasswordState?.isLoading, true);
      expect(states[1].changePasswordState?.isLoading, false);
      expect(states[1].changePasswordState?.errorMessage, 'Wrong password');

      await subscription.cancel();
    });

    test(
      'updates session auth token on success with non-empty token',
      () async {
        when(
          mockUseCase(request),
        ).thenAnswer((_) async => SuccessResponse(data: entity));
        when(
          mockSessionController.updateSessionAuth('new_token_abc'),
        ).thenAnswer((_) async {});

        final states = <ChangePasswordStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(ChangePasswordEvent(request: request));
        await Future.delayed(const Duration(milliseconds: 100));

        verify(
          mockSessionController.updateSessionAuth('new_token_abc'),
        ).called(1);

        await subscription.cancel();
      },
    );

    test('does not update session auth when token is empty', () async {
      const emptyTokenEntity = ChangePasswordEntity(
        message: 'Changed',
        token: '',
      );
      when(
        mockUseCase(request),
      ).thenAnswer((_) async => SuccessResponse(data: emptyTokenEntity));

      final states = <ChangePasswordStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(ChangePasswordEvent(request: request));
      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(mockSessionController.updateSessionAuth(any));

      await subscription.cancel();
    });

    test('does not update session auth on error response', () async {
      when(
        mockUseCase(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'fail'));

      final states = <ChangePasswordStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(ChangePasswordEvent(request: request));
      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(mockSessionController.updateSessionAuth(any));

      await subscription.cancel();
    });
  });
}
