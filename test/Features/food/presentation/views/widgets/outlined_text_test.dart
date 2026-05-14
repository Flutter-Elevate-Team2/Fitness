import 'package:fitness_app/Features/food/presentation/views/widgets/outlined_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OutlinedText Widget Tests', () {
    const testText = "Fitness Goal";

    testWidgets('should render two Text widgets with the same content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OutlinedText(text: testText),
          ),
        ),
      );

       expect(find.text(testText), findsNWidgets(2));
    });

    testWidgets('should apply correct colors to stroke and fill', (WidgetTester tester) async {
      const textColor = Colors.red;
      const outlineColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OutlinedText(
              text: testText,
              textColor: textColor,
              outlineColor: outlineColor,
            ),
          ),
        ),
      );

       final strokeText = tester.widget<Text>(
        find.byWidgetPredicate((widget) =>
        widget is Text &&
            widget.data == testText &&
            widget.style?.foreground != null),
      );

       final fillText = tester.widget<Text>(
        find.byWidgetPredicate((widget) =>
        widget is Text &&
            widget.data == testText &&
            widget.style?.color != null),
      );

       expect(strokeText.style!.foreground!.color.colorSpace, outlineColor.colorSpace);
      expect(fillText.style!.color!.colorSpace, textColor.colorSpace);
    });

    testWidgets('should respect maxLines and overflow on both layers', (WidgetTester tester) async {
      const maxLines = 2;
      const overflow = TextOverflow.ellipsis;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OutlinedText(
              text: testText,
              maxLines: maxLines,
              overflow: overflow,
            ),
          ),
        ),
      );

      final textWidgets = tester.widgetList<Text>(find.text(testText));

      for (var textWidget in textWidgets) {
        expect(textWidget.maxLines, maxLines);
        expect(textWidget.overflow, overflow);
      }
    });
  });
}