import 'package:fitness_app/Features/home/presentation/views/screens/home_screen.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(home: HomeScreen());
  }

  group('HomeScreen Integration Tests', () {
    testWidgets('should show Explore tab as the initial screen', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.widgetWithText(Center, 'Explore'), findsOneWidget);

      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });

    testWidgets('should switch pages when nav bar items are tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final chatAiTab = find.descendant(
        of: find.byType(CustomBottomNavBar),
        matching: find.byType(GestureDetector).at(1),
      );

      await tester.tap(chatAiTab);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Center, 'Chat AI'), findsOneWidget);
      expect(find.widgetWithText(Center, 'Explore'), findsNothing);

      final profileTab = find.descendant(
        of: find.byType(CustomBottomNavBar),
        matching: find.byType(GestureDetector).at(3),
      );

      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Center, 'Profile'), findsOneWidget);
    });

    testWidgets('should render backdrop filter for background blur', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets(
      'should verify that only the selected tab shows its label in NavBar',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final navBar = find.byType(CustomBottomNavBar);

        expect(
          find.descendant(of: navBar, matching: find.text('Chat AI')),
          findsNothing,
        );

        expect(
          find.descendant(of: navBar, matching: find.text('Explore')),
          findsOneWidget,
        );
      },
    );
  });
}
