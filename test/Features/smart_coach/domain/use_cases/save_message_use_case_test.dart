import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/save_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class MockSmartCoachRepo extends Mock implements SmartCoachRepoContract {}

void main() {
  late MockSmartCoachRepo mockRepo;
  late SaveMessageUseCase saveMessageUseCase;

  setUp(() {
    mockRepo = MockSmartCoachRepo();
    saveMessageUseCase = SaveMessageUseCase(mockRepo);
  });

  group('SaveMessageUseCase', () {
    const tSessionId = 'session-123';
    const tDefaultTitle = 'New Chat';
    final tMessage = MessageEntity(
      id: 'msg-123',
      content: 'Hello',
      isUser: true,
      timestamp: DateTime(2023),
    );

    test('should call repo.saveMessage with correct params and return SuccessResponse', () async {
      when(() => mockRepo.saveMessage(
            sessionId: tSessionId,
            message: tMessage,
            defaultTitle: tDefaultTitle,
          )).thenAnswer((_) async => const SuccessResponse(data: null));

      final result = await saveMessageUseCase(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRepo.saveMessage(
            sessionId: tSessionId,
            message: tMessage,
            defaultTitle: tDefaultTitle,
          )).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse when repo fails', () async {
      when(() => mockRepo.saveMessage(
            sessionId: tSessionId,
            message: tMessage,
            defaultTitle: tDefaultTitle,
          )).thenAnswer((_) async => const ErrorResponse(errorMessage: 'Cannot save'));

      final result = await saveMessageUseCase(
        sessionId: tSessionId,
        message: tMessage,
        defaultTitle: tDefaultTitle,
      );

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'Cannot save');
      verify(() => mockRepo.saveMessage(
            sessionId: tSessionId,
            message: tMessage,
            defaultTitle: tDefaultTitle,
          )).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
