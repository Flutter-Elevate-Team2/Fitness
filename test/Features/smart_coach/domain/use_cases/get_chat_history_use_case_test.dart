import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/get_chat_history_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class MockSmartCoachRepo extends Mock implements SmartCoachRepoContract {}

void main() {
  late MockSmartCoachRepo mockRepo;
  late GetChatHistoryUseCase getChatHistoryUseCase;

  setUp(() {
    mockRepo = MockSmartCoachRepo();
    getChatHistoryUseCase = GetChatHistoryUseCase(mockRepo);
  });

  group('GetChatHistoryUseCase', () {
    final tSessions = [
      ChatSessionEntity(
        id: 'session-123',
        title: 'Title',
        messages: const [],
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      ),
    ];

    test('should call repo.getChatHistory and return SuccessResponse with data', () async {
      when(() => mockRepo.getChatHistory())
          .thenAnswer((_) async => SuccessResponse(data: tSessions));

      final result = await getChatHistoryUseCase();

      expect(result, isA<SuccessResponse<List<ChatSessionEntity>>>());
      expect((result as SuccessResponse).data, tSessions);
      verify(() => mockRepo.getChatHistory()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse when repo fails', () async {
      when(() => mockRepo.getChatHistory())
          .thenAnswer((_) async => const ErrorResponse(errorMessage: 'Empty DB'));

      final result = await getChatHistoryUseCase();

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'Empty DB');
      verify(() => mockRepo.getChatHistory()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
