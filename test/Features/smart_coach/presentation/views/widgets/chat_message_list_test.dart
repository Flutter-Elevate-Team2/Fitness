import 'package:fitness_app/Features/smart_coach/domain/entities/message_entity.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_message_list.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/coach_message_bubble.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/user_message_bubble.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserCubit extends Mock implements UserCubit {
  @override
  UserEntity? get state => null;

  @override
  Stream<UserEntity?> get stream => const Stream.empty();

  @override
  bool get isClosed => false;

  @override
  Future<void> close() async {}
}

void main() {
  late ScrollController scrollController;
  late MockUserCubit mockUserCubit;

  setUp(() {
    scrollController = ScrollController();
    mockUserCubit = MockUserCubit();
  });

  tearDown(() {
    scrollController.dispose();
  });

  Widget buildTestWidget({
    required List<MessageEntity> messages,
    bool isStreaming = false,
    bool showRetry = false,
    VoidCallback? onRetry,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<UserCubit>.value(
        value: mockUserCubit,
        child: Scaffold(
          body: ChatMessageList(
            messages: messages,
            scrollController: scrollController,
            isStreaming: isStreaming,
            showRetry: showRetry,
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }

  group('ChatMessageList Widget Tests', () {
    testWidgets('renders empty state when messages list is empty', (tester) async {
      await tester.pumpWidget(buildTestWidget(messages: []));
      
      expect(find.byType(Image), findsOneWidget); // Verifies the robot image
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders list of User and Coach message bubbles', (tester) async {
      final messages = [
        MessageEntity(id: '1', content: 'Hello user', isUser: false, timestamp: DateTime.now()),
        MessageEntity(id: '2', content: 'Hello coach', isUser: true, timestamp: DateTime.now()),
      ];
      
      await tester.pumpWidget(buildTestWidget(messages: messages));
      
      expect(find.byType(UserMessageBubble), findsOneWidget);
      expect(find.byType(CoachMessageBubble), findsOneWidget);
    });

    testWidgets('renders TypingIndicator when streaming and empty AI message exists', (tester) async {
      final messages = [
        MessageEntity(id: '1', content: '', isUser: false, timestamp: DateTime.now()), // Empty streaming AI placeholder
        MessageEntity(id: '2', content: 'What is my plan?', isUser: true, timestamp: DateTime.now()),
      ];
      
      await tester.pumpWidget(buildTestWidget(messages: messages, isStreaming: true));
      
      // Match the private _TypingIndicator by its class name
      expect(
        find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_TypingIndicator'),
        findsOneWidget,
      );
    });

    testWidgets('renders Retry button and calls onRetry when showRetry is true', (tester) async {
      bool retryPressed = false;
      final messages = [
        MessageEntity(id: '1', content: 'Network Error', isUser: false, timestamp: DateTime.now()),
      ];
      
      await tester.pumpWidget(buildTestWidget(
        messages: messages,
        showRetry: true,
        onRetry: () => retryPressed = true,
      ));
      
      final retryButton = find.byIcon(Icons.refresh);
      expect(retryButton, findsOneWidget);
      
      await tester.tap(retryButton);
      // Use pump() instead of pumpAndSettle() because _TypingIndicator
      // may have an AnimationController.repeat() that never settles.
      await tester.pump();
      
      expect(retryPressed, isTrue);
    });
  });
}
