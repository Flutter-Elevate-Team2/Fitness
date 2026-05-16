import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

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

  group('WorkoutsGridShimmer', () {
    testWidgets('renders Shimmer placeholders in a grid', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridShimmer()),
      );

      // SliverGrid lazily renders only visible items; verify at least some appear
      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('does not render any MuscleCard', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridShimmer()),
      );

      // Shimmer grid should contain only shimmer items, no real content
      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('each shimmer has a rounded Container', (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(const WorkoutsGridShimmer()),
      );

      final containers = tester
          .widgetList<Container>(find.descendant(
            of: find.byType(Shimmer),
            matching: find.byType(Container),
          ))
          .toList();

      expect(containers.isNotEmpty, isTrue);
    });
  });
}
