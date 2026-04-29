import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/create_chat_session_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class MockSmartCoachRepo extends Mock implements SmartCoachRepoContract {}

void main() {
  late MockSmartCoachRepo mockRepo;
  late CreateChatSessionUseCase createChatSessionUseCase;

  setUp(() {
    mockRepo = MockSmartCoachRepo();
    createChatSessionUseCase = CreateChatSessionUseCase(mockRepo);
  });

  group('CreateChatSessionUseCase', () {
    const tDefaultTitle = 'New Chat';
    final tSession = ChatSessionEntity(
      id: 'session-123',
      title: tDefaultTitle,
      messages: const [],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    test('should call repo.createSession with correct params and return SuccessResponse', () async {
      when(() => mockRepo.createSession(defaultTitle: tDefaultTitle))
          .thenAnswer((_) async => SuccessResponse(data: tSession));

      final result = await createChatSessionUseCase(defaultTitle: tDefaultTitle);

      expect(result, isA<SuccessResponse<ChatSessionEntity>>());
      expect((result as SuccessResponse).data, tSession);
      verify(() => mockRepo.createSession(defaultTitle: tDefaultTitle)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ErrorResponse when repo fails', () async {
      when(() => mockRepo.createSession(defaultTitle: tDefaultTitle))
          .thenAnswer((_) async => const ErrorResponse(errorMessage: 'DB Error'));

      final result = await createChatSessionUseCase(defaultTitle: tDefaultTitle);

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).errorMessage, 'DB Error');
      verify(() => mockRepo.createSession(defaultTitle: tDefaultTitle)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
