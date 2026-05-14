import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_indicator.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  late PageController pageController;

  setUp(() {
    pageController = PageController();
  });

  Widget createWidgetUnderTest({required int count}) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        body: OnboardingIndicator(pageController: pageController, count: count),
      ),
    );
  }

  group('OnboardingIndicator Tests', () {
    testWidgets('should render SmoothPageIndicator with correct count', (
      tester,
    ) async {
      // Arrange
      const testCount = 3;

      // Act
      await tester.pumpWidget(createWidgetUnderTest(count: testCount));

      // Assert
      expect(find.byType(SmoothPageIndicator), findsOneWidget);

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      expect(indicator.count, testCount);
    });

    testWidgets('should have ExpandingDotsEffect with correct custom colors', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(count: 3));

      // Assert
      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );

      expect(indicator.effect, isA<ExpandingDotsEffect>());

      final effect = indicator.effect as ExpandingDotsEffect;
      expect(effect.activeDotColor, Colors.blue);
      expect(effect.dotColor, AppColors.white);
      expect(effect.dotHeight, 8);
      expect(effect.dotWidth, 8);
      expect(effect.expansionFactor, 3);
    });
  });
}
