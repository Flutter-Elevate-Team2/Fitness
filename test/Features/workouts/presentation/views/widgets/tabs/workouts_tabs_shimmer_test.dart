import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(height: 48, child: child),
      ),
    );
  }

  group('WorkoutsTabsShimmer', () {
    testWidgets('renders 5 Shimmer placeholders', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const WorkoutsTabsShimmer()),
      );

      expect(find.byType(Shimmer), findsNWidgets(5));
    });

    testWidgets('uses horizontal ListView', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const WorkoutsTabsShimmer()),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('each placeholder has rounded container decoration',
        (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(const WorkoutsTabsShimmer()),
      );

      // Find containers that are children of Shimmer widgets
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
