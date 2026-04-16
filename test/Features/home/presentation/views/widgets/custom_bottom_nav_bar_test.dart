import 'package:fitness_app/Features/home/presentation/views/widgets/custom_bottom_nav_bar.dart'; // تأكدي من المسار
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  group('CustomBottomNavBar Widget Tests', () {
    testWidgets('should render all navigation items', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 0, onTap: (_) {}),
      );

      // Assert
      expect(find.byType(Image), findsNWidgets(4));

      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Chat AI'), findsNothing);
    });

    testWidgets('should show label only for the selected item', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 2, onTap: (_) {}),
      );

      // Assert
      expect(find.text('Workouts'), findsOneWidget);
      expect(find.text('Explore'), findsNothing);
    });

    testWidgets(
      'should call onTap with correct index when an item is pressed',
      (WidgetTester tester) async {
        int tappedIndex = -1;

        // Act
        await tester.pumpWidget(
          createWidgetUnderTest(
            currentIndex: 0,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        );

        final chatAiItem = find.byType(GestureDetector).at(1);
        await tester.tap(chatAiItem);
        await tester.pump();

        // Assert
        expect(tappedIndex, 1);
      },
    );

    testWidgets('should change active color when index changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 3, onTap: (_) {}),
      );

      final image = tester.widget<Image>(find.byType(Image).at(3));

      expect(image.color, isNotNull);
    });
  });
}
