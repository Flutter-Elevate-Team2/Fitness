import 'package:fitness_app/Features/food/presentation/views/widgets/expandable_text.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
   late String showMoreLabel;
  late String showLessLabel;

  Widget createTestWidget(String text) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
       home: Scaffold(
        body: Builder(
          builder: (context) {
             showMoreLabel = AppLocalizations.of(context)!.showMore;
            showLessLabel = AppLocalizations.of(context)!.showLess;
            return ExpandableText(text: text);
          },
        ),
      ),
    );
  }

  group('ExpandableText Widget Tests', () {
    testWidgets('should show full text without "Show More" if text is short',
            (WidgetTester tester) async {
           const shortText = "Short text example";

          await tester.pumpWidget(createTestWidget(shortText));
          await tester.pumpAndSettle();

          expect(find.text(shortText), findsOneWidget);
           expect(find.text(showMoreLabel), findsNothing);
        });

    testWidgets('should show "Show More" when text exceeds 120 characters',
            (WidgetTester tester) async {
           final longText = "A" * 150;

          await tester.pumpWidget(createTestWidget(longText));
          await tester.pumpAndSettle();

          expect(find.text(showMoreLabel), findsOneWidget);
        });

    testWidgets('should expand text and show "Show Less" when "Show More" is tapped',
            (WidgetTester tester) async {
          final longText = "A" * 150;
          await tester.pumpWidget(createTestWidget(longText));
          await tester.pumpAndSettle();

           await tester.tap(find.text(showMoreLabel));
          await tester.pump();

           expect(find.text(showLessLabel), findsOneWidget);

           final textWidget = tester.widget<Text>(find.byType(Text).first);
          expect(textWidget.maxLines, isNull);
        });

    testWidgets('should collapse text when "Show Less" is tapped',
            (WidgetTester tester) async {
          final longText = "A" * 150;
          await tester.pumpWidget(createTestWidget(longText));
          await tester.pumpAndSettle();

           await tester.tap(find.text(showMoreLabel));
          await tester.pump();

           await tester.tap(find.text(showLessLabel));
          await tester.pump();

           expect(find.text(showMoreLabel), findsOneWidget);
          final textWidget = tester.widget<Text>(find.byType(Text).first);
          expect(textWidget.maxLines, equals(3));
        });
  });
}
