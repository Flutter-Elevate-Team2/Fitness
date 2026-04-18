import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_content_widget.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testEntity = OnboardingEntity(
    title: 'Test Title',
    description: 'Test Description',
    image: 'test_image.png',
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(body: OnboardingContentWidget(entity: testEntity)),
    );
  }

  group('OnboardingContentWidget Tests', () {
    testWidgets('should display the correct title and description', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should apply the correct text styles', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      final titleText = tester.widget<Text>(find.text('Test Title'));
      expect(titleText.style?.color, AppColors.white);
      expect(titleText.style?.fontSize, 26);
      expect(titleText.textAlign, TextAlign.center);

      final descText = tester.widget<Text>(find.text('Test Description'));
      expect(descText.style?.color, AppColors.light400);
      expect(descText.style?.fontSize, 14);
      expect(descText.textAlign, TextAlign.center);
    });

    testWidgets('should handle long text with ellipsis and maxLines', (
      WidgetTester tester,
    ) async {
      var longEntity = OnboardingEntity(
        title:
            'This is a very very long title that should exceed two lines in normal cases',
        description: 'Description',
        image: 'image.png',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OnboardingContentWidget(entity: longEntity)),
        ),
      );

      // Assert
      final titleText = tester.widget<Text>(
        find.textContaining('very very long'),
      );
      expect(titleText.maxLines, 2);
      expect(titleText.overflow, TextOverflow.ellipsis);
    });
  });
}
