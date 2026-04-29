import 'package:fitness_app/Features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_history_item.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_history_panel.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    required bool isOpen,
    required List<ChatSessionEntity> sessions,
    VoidCallback? onClose,
    void Function(ChatSessionEntity)? onSessionTap,
    VoidCallback? onNewChat,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ChatHistoryPanel(
          isOpen: isOpen,
          onClose: onClose ?? () {},
          sessions: sessions,
          onSessionTap: onSessionTap,
          onNewChat: onNewChat,
        ),
      ),
    );
  }

  group('ChatHistoryPanel Widget Tests', () {
    testWidgets('renders nothing/scrim depending on isOpen state', (tester) async {
      // Test when isOpen = false
      await tester.pumpWidget(buildTestWidget(isOpen: false, sessions: []));
      
      final slideWhenClosed = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
      expect(slideWhenClosed.offset, const Offset(1, 0)); // Hidden completely off-screen

      // Test when isOpen = true
      bool closedTriggered = false;
      await tester.pumpWidget(buildTestWidget(
        isOpen: true, 
        sessions: [], 
        onClose: () => closedTriggered = true,
      ));
      await tester.pumpAndSettle();

      final slideWhenOpen = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
      expect(slideWhenOpen.offset, Offset.zero); // Fully visible

      // The scrim barrier covers the whole screen, we can tap anywhere not on the panel (e.g. left edge)
      await tester.tapAt(const Offset(10, 10)); 
      expect(closedTriggered, isTrue);
    });

    testWidgets('renders a list of ChatHistoryItems based on provided sessions', (tester) async {
      final sessions = [
        ChatSessionEntity(id: '1', title: 'Cardio Plan', updatedAt: DateTime.now(), createdAt: DateTime.now(), messages: const []),
        ChatSessionEntity(id: '2', title: 'Diet Rules', updatedAt: DateTime.now(), createdAt: DateTime.now(), messages: const []),
      ];

      await tester.pumpWidget(buildTestWidget(isOpen: true, sessions: sessions));
      await tester.pumpAndSettle();

      expect(find.byType(ChatHistoryItem), findsNWidgets(2));
    });

    testWidgets('verify onSessionTap and onNewChat callbacks are fired when tapped', (tester) async {
      ChatSessionEntity? tappedSession;
      bool newChatTriggered = false;

      final sessions = [
        ChatSessionEntity(id: '1', title: 'Workout A', updatedAt: DateTime.now(), createdAt: DateTime.now(), messages: const []),
      ];

      await tester.pumpWidget(buildTestWidget(
        isOpen: true, 
        sessions: sessions,
        onSessionTap: (session) => tappedSession = session,
        onNewChat: () => newChatTriggered = true,
      ));
      await tester.pumpAndSettle();

      // Tap on new chat button (plus icon)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(newChatTriggered, isTrue);

      // Tap on the history item
      await tester.tap(find.byType(ChatHistoryItem).first);
      await tester.pumpAndSettle();
      expect(tappedSession?.id, '1');
    });
  });
}
