import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_empty.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableSliver(Widget sliver) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [sliver],
        ),
      ),
    );
  }

  group('WorkoutsGridEmpty', () {
    testWidgets('renders the empty state message', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridEmpty()),
      );

      expect(
        find.text('No exercise routines found for this muscle group.'),
        findsOneWidget,
      );
    });

    testWidgets('applies white text color', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridEmpty()),
      );

      final text = tester.widget<Text>(
        find.text('No exercise routines found for this muscle group.'),
      );
      expect(text.style?.color, AppColors.white);
    });

    testWidgets('is centered with padding', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridEmpty()),
      );

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('is wrapped in SliverToBoxAdapter', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridEmpty()),
      );

      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });
  });
}
