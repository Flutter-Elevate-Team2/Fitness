import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_error.dart';
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

  group('WorkoutsGridError', () {
    testWidgets('renders the provided error message', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          const WorkoutsGridError(errorMessage: 'Server unavailable'),
        ),
      );

      expect(find.text('Server unavailable'), findsOneWidget);
    });

    testWidgets('applies red text color', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          const WorkoutsGridError(errorMessage: 'Error'),
        ),
      );

      final text = tester.widget<Text>(find.text('Error'));
      expect(text.style?.color, AppColors.red);
    });

    testWidgets('text is center aligned', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          const WorkoutsGridError(errorMessage: 'Something went wrong'),
        ),
      );

      final text = tester.widget<Text>(find.text('Something went wrong'));
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('is wrapped in SliverToBoxAdapter', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          const WorkoutsGridError(errorMessage: 'Error'),
        ),
      );

      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });
  });
}
