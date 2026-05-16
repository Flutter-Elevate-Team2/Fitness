import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/delete_chat_session_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class MockSmartCoachRepo extends Mock implements SmartCoachRepoContract {}

void main() {
  late MockSmartCoachRepo mockRepo;
  late DeleteChatSessionUseCase deleteChatSessionUseCase;

  setUp(() {
    mockRepo = MockSmartCoachRepo();
    deleteChatSessionUseCase = DeleteChatSessionUseCase(mockRepo);
  });

  group('DeleteChatSessionUseCase', () {
    const tSessionId = 'session-123';

    test('should call repo.deleteSession with correct params and return SuccessResponse', () async {
      when(() => mockRepo.deleteSession(tSessionId))
          .thenAnswer((_) async => const SuccessResponse(data: null));

      final result = await deleteChatSessionUseCase(tSessionId);

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRepo.deleteSession(tSessionId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse when repo fails', () async {
      when(() => mockRepo.deleteSession(tSessionId))
          .thenAnswer((_) async => const ErrorResponse(errorMessage: 'Not Found'));

      final result = await deleteChatSessionUseCase(tSessionId);

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'Not Found');
      verify(() => mockRepo.deleteSession(tSessionId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
