import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/gender_selection_button.dart';
import 'package:fitness_app/core/theming/app_colors.dart';

void main() {
  group('GenderSelectionButton', () {
    testWidgets('displays label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderSelectionButton(
              label: 'Male',
              imagePath: 'assets/icons/male.png',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Male'), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderSelectionButton(
              label: 'Female',
              imagePath: 'assets/icons/female.png',
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
    });

    testWidgets('uses primary color when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderSelectionButton(
              label: 'Male',
              imagePath: 'assets/icons/male.png',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Male'));
      expect(text.style?.color, AppColors.primary);
    });

    testWidgets('uses white color when not selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderSelectionButton(
              label: 'Female',
              imagePath: 'assets/icons/female.png',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Female'));
      expect(text.style?.color, AppColors.white);
    });

    testWidgets('contains an AnimatedContainer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderSelectionButton(
              label: 'Male',
              imagePath: 'assets/icons/male.png',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('contains an Image widget for the icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderSelectionButton(
              label: 'Male',
              imagePath: 'assets/icons/male.png',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });
}
