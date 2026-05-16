import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/horizontal_number_picker.dart';
import 'package:fitness_app/core/theming/app_colors.dart';

void main() {
  group('HorizontalNumberPicker', () {
    testWidgets('displays the unit label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 14,
              maxValue: 100,
              initialValue: 25,
              unitLabel: 'Year',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Year'), findsOneWidget);
    });

    testWidgets('displays the initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 14,
              maxValue: 100,
              initialValue: 25,
              unitLabel: 'Year',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('contains a PageView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 30,
              maxValue: 200,
              initialValue: 70,
              unitLabel: 'Kg',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('shows the triangle indicator icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 100,
              maxValue: 250,
              initialValue: 170,
              unitLabel: 'CM',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
    });

    testWidgets('unit label has primary color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 14,
              maxValue: 100,
              initialValue: 25,
              unitLabel: 'Year',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final label = tester.widget<Text>(find.text('Year'));
      expect(label.style?.color, AppColors.primary);
    });

    testWidgets('calls onChanged when page changes',
        (WidgetTester tester) async {
      int? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 14,
              maxValue: 100,
              initialValue: 25,
              unitLabel: 'Year',
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      // Swipe left to go to next page
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
    });
  });
}
