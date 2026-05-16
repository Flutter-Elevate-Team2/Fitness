import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/delete_message_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class MockSmartCoachRepo extends Mock implements SmartCoachRepoContract {}

void main() {
  late MockSmartCoachRepo mockRepo;
  late DeleteMessageUseCase deleteMessageUseCase;

  setUp(() {
    mockRepo = MockSmartCoachRepo();
    deleteMessageUseCase = DeleteMessageUseCase(mockRepo);
  });

  group('DeleteMessageUseCase', () {
    const tSessionId = 'session-123';
    const tMessageId = 'msg-123';

    test('should call repo.deleteMessage with correct params and return SuccessResponse', () async {
      when(() => mockRepo.deleteMessage(sessionId: tSessionId, messageId: tMessageId))
          .thenAnswer((_) async => const SuccessResponse(data: null));

      final result = await deleteMessageUseCase(sessionId: tSessionId, messageId: tMessageId);

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRepo.deleteMessage(sessionId: tSessionId, messageId: tMessageId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse when repo fails', () async {
      when(() => mockRepo.deleteMessage(sessionId: tSessionId, messageId: tMessageId))
          .thenAnswer((_) async => const ErrorResponse(errorMessage: 'Error deleting'));

      final result = await deleteMessageUseCase(sessionId: tSessionId, messageId: tMessageId);

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'Error deleting');
      verify(() => mockRepo.deleteMessage(sessionId: tSessionId, messageId: tMessageId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
