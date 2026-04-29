import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/send_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';

class MockSmartCoachRepo extends Mock implements SmartCoachRepoContract {}

void main() {
  late MockSmartCoachRepo mockRepo;
  late SendMessageUseCase sendMessageUseCase;

  setUp(() {
    mockRepo = MockSmartCoachRepo();
    sendMessageUseCase = SendMessageUseCase(mockRepo);
  });

  group('SendMessageUseCase', () {
    const tSessionId = 'session-123';
    const tUserMessage = 'Hi Coach';
    final tHistory = <MessageEntity>[];

    test('should call repo.sendMessage with correct params and return Stream of tokens', () async {
      final tStream = Stream.fromIterable(['Hello', ' world!']);
      when(() => mockRepo.sendMessage(
            sessionId: tSessionId,
            userMessage: tUserMessage,
            history: tHistory,
          )).thenAnswer((_) => tStream);

      final result = sendMessageUseCase(
        sessionId: tSessionId,
        userMessage: tUserMessage,
        history: tHistory,
      );

      expect(result, emitsInOrder(['Hello', ' world!', emitsDone]));
      verify(() => mockRepo.sendMessage(
            sessionId: tSessionId,
            userMessage: tUserMessage,
            history: tHistory,
          )).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should propagate errors through the stream', () async {
      final tStream = Stream<String>.error('Network Error');
      when(() => mockRepo.sendMessage(
            sessionId: tSessionId,
            userMessage: tUserMessage,
            history: tHistory,
          )).thenAnswer((_) => tStream);

      final result = sendMessageUseCase(
        sessionId: tSessionId,
        userMessage: tUserMessage,
        history: tHistory,
      );

      expect(result, emitsError('Network Error'));
      verify(() => mockRepo.sendMessage(
            sessionId: tSessionId,
            userMessage: tUserMessage,
            history: tHistory,
          )).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
