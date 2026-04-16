import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/custom_selection_tile.dart';
import 'package:fitness_app/core/theming/app_colors.dart';

void main() {
  group('CustomSelectionTile', () {
    testWidgets('displays the title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSelectionTile(
              title: 'Gain Weight',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Gain Weight'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSelectionTile(
              title: 'Lose Weight',
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('shows primary border when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSelectionTile(
              title: 'Get Fitter',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the outer decorated Container
      final containers = tester.widgetList<Container>(find.byType(Container));
      final decorated = containers.where((c) {
        if (c.decoration is BoxDecoration) {
          final bd = c.decoration as BoxDecoration;
          return bd.border != null;
        }
        return false;
      });
      expect(decorated.isNotEmpty, isTrue);
    });

    testWidgets('shows inner circle indicator when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSelectionTile(
              title: 'Rookie',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // When selected, the inner 8x8 primary circle should exist
      final innerCircles = tester.widgetList<Container>(
        find.byType(Container),
      ).where((c) {
        if (c.decoration is BoxDecoration) {
          final bd = c.decoration as BoxDecoration;
          return bd.shape == BoxShape.circle && bd.color == AppColors.primary;
        }
        return false;
      });
      expect(innerCircles.isNotEmpty, isTrue);
    });

    testWidgets('does NOT show inner circle when unselected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSelectionTile(
              title: 'Beginner',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      // When unselected, no 8x8 inner circle with primary color
      final innerCircles = tester.widgetList<Container>(
        find.byType(Container),
      ).where((c) {
        if (c.decoration is BoxDecoration) {
          final bd = c.decoration as BoxDecoration;
          return bd.shape == BoxShape.circle &&
              bd.color == AppColors.primary &&
              c.constraints?.maxWidth == 8;
        }
        return false;
      });
      expect(innerCircles.isEmpty, isTrue);
    });
  });
}
