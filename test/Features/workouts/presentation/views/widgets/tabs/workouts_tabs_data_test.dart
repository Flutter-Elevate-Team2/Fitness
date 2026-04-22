import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_group_tab.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _tGroups = [
  MuscleGroupEntity(id: '1', name: 'Chest'),
  MuscleGroupEntity(id: '2', name: 'Back'),
  MuscleGroupEntity(id: '3', name: 'Legs'),
];

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(height: 48, child: child),
      ),
    );
  }

  group('WorkoutsTabsData', () {
    testWidgets('renders a MuscleGroupTab for each group', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          WorkoutsTabsData(
            groups: _tGroups,
            selectedGroupId: '1',
            onTabSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(MuscleGroupTab), findsNWidgets(3));
      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Legs'), findsOneWidget);
    });

    testWidgets('calls onTabSelected with correct group ID when tapped',
        (tester) async {
      String? tappedId;

      await tester.pumpWidget(
        makeTestableWidget(
          WorkoutsTabsData(
            groups: _tGroups,
            selectedGroupId: '1',
            onTabSelected: (id) => tappedId = id,
          ),
        ),
      );

      await tester.tap(find.text('Back'));
      expect(tappedId, '2');
    });

    testWidgets('calls onTabSelected with first group ID when tapped',
        (tester) async {
      String? tappedId;

      await tester.pumpWidget(
        makeTestableWidget(
          WorkoutsTabsData(
            groups: _tGroups,
            selectedGroupId: '2',
            onTabSelected: (id) => tappedId = id,
          ),
        ),
      );

      await tester.tap(find.text('Chest'));
      expect(tappedId, '1');
    });

    testWidgets('renders empty list when groups is empty', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          WorkoutsTabsData(
            groups: const [],
            selectedGroupId: null,
            onTabSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(MuscleGroupTab), findsNothing);
    });

    testWidgets('uses horizontal ListView', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          WorkoutsTabsData(
            groups: _tGroups,
            selectedGroupId: '1',
            onTabSelected: (_) {},
          ),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });
  });
}
