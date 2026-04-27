 import 'package:fitness_app/Features/workouts/presentation/views/widgets/exercises_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('Shimmer Widgets Tests', () {

    testWidgets('DifficultyTabsShimmer should render correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DifficultyTabsShimmer()),
        ),
      );

       expect(find.byType(Shimmer), findsWidgets);

       expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('ExercisesListShimmer should render 4 items with correct structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ExercisesListShimmer()),
        ),
      );

    final containers = tester.widgetList<Container>(find.byType(Container));
      final thumbnailContainers = containers.where((c) {
        final box = c.constraints;
        return box?.maxWidth == 80 && box?.maxHeight == 80;
      });

      expect(thumbnailContainers.length, equals(4));

       expect(find.byType(Divider), findsNWidgets(3)); // 4 items means 3 separators
    });
  });
}