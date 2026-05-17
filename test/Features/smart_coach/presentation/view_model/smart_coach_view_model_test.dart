import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/create_chat_session_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/delete_chat_session_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/delete_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/get_chat_history_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/save_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/send_message_use_case.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/errors/gemini_safety_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks ---
class MockCreateChatSessionUseCase extends Mock implements CreateChatSessionUseCase {}
class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}
class MockSaveMessageUseCase extends Mock implements SaveMessageUseCase {}
class MockGetChatHistoryUseCase extends Mock implements GetChatHistoryUseCase {}
class MockDeleteChatSessionUseCase extends Mock implements DeleteChatSessionUseCase {}
class MockDeleteMessageUseCase extends Mock implements DeleteMessageUseCase {}

void main() {
  late SmartCoachViewModel viewModel;
  late MockCreateChatSessionUseCase mockCreateChatSession;
  late MockSendMessageUseCase mockSendMessage;
  late MockSaveMessageUseCase mockSaveMessage;
  late MockGetChatHistoryUseCase mockGetChatHistory;
  late MockDeleteChatSessionUseCase mockDeleteChatSession;
  late MockDeleteMessageUseCase mockDeleteMessage;

  setUpAll(() {
    registerFallbackValue(MessageEntity(
      id: 'dummy',
      content: 'dummy',
      isUser: true,
      timestamp: DateTime.now(),
    ));
    registerFallbackValue(<MessageEntity>[]);
  });

  setUp(() {
    mockCreateChatSession = MockCreateChatSessionUseCase();
    mockSendMessage = MockSendMessageUseCase();
    mockSaveMessage = MockSaveMessageUseCase();
    mockGetChatHistory = MockGetChatHistoryUseCase();
    mockDeleteChatSession = MockDeleteChatSessionUseCase();
    mockDeleteMessage = MockDeleteMessageUseCase();

    viewModel = SmartCoachViewModel(
      mockCreateChatSession,
      mockSendMessage,
      mockSaveMessage,
      mockGetChatHistory,
      mockDeleteChatSession,
      mockDeleteMessage,
    );

    // 2. Setup: Inject localized strings before tests
    viewModel.setLocalizedStrings(
      defaultSessionTitle: 'New Chat',
      safetyBlockMessage: 'Message blocked due to safety reasons.',
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('SmartCoachViewModel Tests', () {
    // 3. Test loadHistory (No Active Session)
    blocTest<SmartCoachViewModel, SmartCoachState>(
      'emits [SmartCoachLoading, SmartCoachSessionLoaded] when loadHistory is called and no active session',
      build: () {
        when(() => mockGetChatHistory()).thenAnswer(
          (_) async => SuccessResponse(data: [
            ChatSessionEntity(
              id: '1',
              title: 'Session 1',
              updatedAt: DateTime.now(),
              createdAt: DateTime.now(),
              messages: const [],
            )
          ]),
        );
        return viewModel;
      },
      act: (bloc) => bloc.loadHistory(),
      expect: () => [
        isA<SmartCoachLoading>(),
        isA<SmartCoachSessionLoaded>()
            .having((state) => state.sessions.length, 'sessions length', 1)
            .having((state) => state.sessions.first.id, 'session id', '1'),
      ],
    );

    // 3. Test loadHistory (With Active Session)
    blocTest<SmartCoachViewModel, SmartCoachState>(
      'emits [SmartCoachStreamDone] when loadHistory is called and there is an active session',
      build: () {
        when(() => mockGetChatHistory()).thenAnswer(
          (_) async => const SuccessResponse(data: <ChatSessionEntity>[]),
        );
        return viewModel;
      },
      seed: () => const SmartCoachStreamDone(messages: []),
      act: (bloc) {
        bloc.loadSession('session_123', []);
        bloc.loadHistory();
      },
      skip: 1, // Skip the state emitted by loadSession
      expect: () => [
        isA<SmartCoachStreamDone>(),
      ],
    );

    // 4. Test createSession
    blocTest<SmartCoachViewModel, SmartCoachState>(
      'emits [SmartCoachStreamDone] and updates currentSessionId when createSession is called',
      build: () {
        when(() => mockCreateChatSession(defaultTitle: any(named: 'defaultTitle'))).thenAnswer(
          (_) async => SuccessResponse(
            data: ChatSessionEntity(
              id: 'new_session',
              title: 'New Chat',
              updatedAt: DateTime.now(),
              createdAt: DateTime.now(),
              messages: const [],
            ),
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.createSession(),
      expect: () => [
        isA<SmartCoachStreamDone>().having((state) => state.messages, 'messages', isEmpty),
      ],
      verify: (bloc) {
        expect(bloc.currentSessionId, 'new_session');
        verify(() => mockCreateChatSession(defaultTitle: 'New Chat')).called(1);
      },
    );

    // 5. Test sendMessage (Success Flow)
    blocTest<SmartCoachViewModel, SmartCoachState>(
      'sendMessage emits Streaming and StreamDone states sequentially, and saves messages',
      build: () {
        when(() => mockSaveMessage(
              sessionId: any(named: 'sessionId'),
              message: any(named: 'message'),
              defaultTitle: any(named: 'defaultTitle'),
            )).thenAnswer((_) async => const SuccessResponse(data: null));

        when(() => mockSendMessage(
              sessionId: any(named: 'sessionId'),
              userMessage: any(named: 'userMessage'),
              history: any(named: 'history'),
            )).thenAnswer((_) => Stream.fromIterable(['Hello ', 'World']));

        return viewModel;
      },
      act: (bloc) => bloc.sendMessage('session_123', 'Hi'),
      expect: () => [
        // 1. User message inserted
        isA<SmartCoachStreaming>()
            .having((s) => s.messages.length, 'length', 1)
            .having((s) => s.messages.first.content, 'user msg', 'Hi')
            .having((s) => s.messages.first.isUser, 'isUser', true),
        // 2. AI placeholder inserted
        isA<SmartCoachStreaming>()
            .having((s) => s.messages.length, 'length', 2)
            .having((s) => s.messages.first.content, 'placeholder', '')
            .having((s) => s.messages.first.isUser, 'isUser', false),
        // 3. First stream chunk
        isA<SmartCoachStreaming>().having((s) => s.messages.first.content, 'chunk 1', 'Hello '),
        // 4. Second stream chunk
        isA<SmartCoachStreaming>().having((s) => s.messages.first.content, 'chunk 2', 'Hello World'),
        // 5. Stream successfully done
        isA<SmartCoachStreamDone>().having((s) => s.messages.first.content, 'final text', 'Hello World'),
      ],
      verify: (bloc) {
        verify(() => mockSaveMessage(
              sessionId: 'session_123',
              message: any(named: 'message', that: isA<MessageEntity>().having((m) => m.isUser, 'isUser', true)),
              defaultTitle: 'New Chat',
            )).called(1);

        verify(() => mockSaveMessage(
              sessionId: 'session_123',
              message: any(named: 'message', that: isA<MessageEntity>().having((m) => m.isUser, 'isUser', false)),
              defaultTitle: 'New Chat',
            )).called(1);
      },
    );

    // 6. Test sendMessage (Error Flow - GeminiSafetyException)
    blocTest<SmartCoachViewModel, SmartCoachState>(
      'sendMessage handles GeminiSafetyException, emits SafetyBlocked, and uses localized string',
      build: () {
        when(() => mockSaveMessage(
              sessionId: any(named: 'sessionId'),
              message: any(named: 'message'),
              defaultTitle: any(named: 'defaultTitle'),
            )).thenAnswer((_) async => const SuccessResponse(data: null));

        when(() => mockSendMessage(
              sessionId: any(named: 'sessionId'),
              userMessage: any(named: 'userMessage'),
              history: any(named: 'history'),
            )).thenAnswer((_) => Stream.error(const GeminiSafetyException('Blocked by filter')));

        return viewModel;
      },
      act: (bloc) => bloc.sendMessage('session_123', 'Dangerous prompt'),
      expect: () => [
        isA<SmartCoachStreaming>(), // User msg streaming state
        isA<SmartCoachStreaming>(), // Placeholder streaming state
        isA<SmartCoachSafetyBlocked>()
            .having((s) => s.messages.first.content, 'safety msg', 'Message blocked due to safety reasons.'),
        isA<SmartCoachStreamDone>(), // Emitted because stream closes after error
      ],
      verify: (bloc) {
        // Must save the user message, the safety message in onError, and again in onDone
        verify(() => mockSaveMessage(
              sessionId: 'session_123',
              message: any(named: 'message'),
              defaultTitle: 'New Chat',
            )).called(3);
      },
    );

    // 7. Test retryLastMessage
    blocTest<SmartCoachViewModel, SmartCoachState>(
      'retryLastMessage deletes failed message and restarts stream with previous user message content',
      build: () {
        when(() => mockSaveMessage(
              sessionId: any(named: 'sessionId'),
              message: any(named: 'message'),
              defaultTitle: any(named: 'defaultTitle'),
            )).thenAnswer((_) async => const SuccessResponse(data: null));

        when(() => mockDeleteMessage(
              sessionId: any(named: 'sessionId'),
              messageId: any(named: 'messageId'),
            )).thenAnswer((_) async => const SuccessResponse(data: null));

        var callCount = 0;
        when(() => mockSendMessage(
              sessionId: any(named: 'sessionId'),
              userMessage: any(named: 'userMessage'),
              history: any(named: 'history'),
            )).thenAnswer((_) {
          callCount++;
          if (callCount == 1) {
            return Stream.error(Exception('Network Error'));
          }
          return Stream.fromIterable(['Retried ', 'Success']);
        });

        return viewModel;
      },
      act: (bloc) async {
        bloc.sendMessage('session_123', 'Retry me');
        // Wait for the initial error stream to finish processing
        await Future.delayed(const Duration(milliseconds: 50));
        
        bloc.retryLastMessage();
        // Wait for the retry stream to finish processing
        await Future.delayed(const Duration(milliseconds: 50));
      },
      skip: 4, // Skip initial 4 states (User msg streaming, Placeholder streaming, Error state, Done state)
      expect: () => [
        isA<SmartCoachStreaming>().having((s) => s.messages.first.content, 'empty placeholder', ''),
        isA<SmartCoachStreaming>().having((s) => s.messages.first.content, 'chunk 1', 'Retried '),
        isA<SmartCoachStreaming>().having((s) => s.messages.first.content, 'chunk 2', 'Retried Success'),
        isA<SmartCoachStreamDone>().having((s) => s.messages.first.content, 'final', 'Retried Success'),
      ],
      verify: (bloc) {
        // Ensure failed message was deleted before retrying
        verify(() => mockDeleteMessage(
              sessionId: 'session_123',
              messageId: any(named: 'messageId'),
            )).called(1);

        // Ensure send message was called twice (initial + retry), using the identical user text
        verify(() => mockSendMessage(
              sessionId: 'session_123',
              userMessage: 'Retry me',
              history: any(named: 'history'),
            )).called(2);
      },
    );
  });
}
