import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/shared_text_item.dart';

void main() {
  group('SharedTextItem', () {
    testWidgets('displays title in uppercase', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SharedTextItem(title: 'test title'),
          ),
        ),
      );

      expect(find.text('TEST TITLE'), findsOneWidget);
    });

    testWidgets('displays subtitle when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SharedTextItem(
              title: 'main',
              subTitle: 'Sub Text Here',
            ),
          ),
        ),
      );

      expect(find.text('MAIN'), findsOneWidget);
      expect(find.text('Sub Text Here'), findsOneWidget);
    });

    testWidgets('does NOT display subtitle when null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SharedTextItem(title: 'only title'),
          ),
        ),
      );

      // Should only find the title, nothing else
      expect(find.text('ONLY TITLE'), findsOneWidget);
      expect(find.byType(FittedBox), findsNothing);
    });

    testWidgets('does NOT display subtitle when empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SharedTextItem(title: 'test', subTitle: ''),
          ),
        ),
      );

      expect(find.byType(FittedBox), findsNothing);
    });

    testWidgets('has horizontal padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SharedTextItem(title: 'padded'),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: 16),
      );
    });
  });
}
