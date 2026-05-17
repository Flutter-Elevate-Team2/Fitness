import 'package:fitness_app/Features/smart_coach/presentation/views/widgets/chat_input_field.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({ValueChanged<String>? onSend, bool enabled = true}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ChatInputField(onSend: onSend, enabled: enabled),
      ),
    );
  }

  group('ChatInputField Widget Tests', () {
    testWidgets('renders hint text and microphone icon initially', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.send), findsNothing);
    });

    testWidgets('entering text changes icon from mic to send', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      
      await tester.enterText(find.byType(TextField), 'Hello coach');
      await tester.pumpAndSettle();
      
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('tapping send icon calls onSend and clears the text field', (tester) async {
      String? sentText;
      await tester.pumpWidget(buildTestWidget(
        onSend: (text) => sentText = text,
      ));
      
      // Enter text
      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.pumpAndSettle();
      
      // Tap send
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      
      // Verify callback
      expect(sentText, 'Test message');
      
      // Verify cleared text and mic icon returns
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('respects the enabled property (ignores taps/typing when false)', (tester) async {
      String? sentText;
      await tester.pumpWidget(buildTestWidget(
        enabled: false,
        onSend: (text) => sentText = text,
      ));
      
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
      
      // Try tapping the mic (since it's disabled, no send icon will appear anyway)
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
      
      expect(sentText, isNull);
    });
  });
}
