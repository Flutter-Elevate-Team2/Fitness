import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_data.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

const _tMuscles = [
  MuscleEntity(id: 'm1', name: 'Pectoralis Major', image: 'https://example.com/pec.png'),
  MuscleEntity(id: 'm2', name: 'Pectoralis Minor', image: 'https://example.com/pec_minor.png'),
  MuscleEntity(id: 'm3', name: 'Deltoid'),
];

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

  group('WorkoutsGridData', () {
    testWidgets('renders a MuscleCard for each muscle', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          makeTestableSliver(const WorkoutsGridData(muscles: _tMuscles)),
        );

        expect(find.byType(MuscleCard), findsNWidgets(3));
      });
    });

    testWidgets('renders muscle names inside cards', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          makeTestableSliver(const WorkoutsGridData(muscles: _tMuscles)),
        );

        expect(find.text('Pectoralis Major'), findsOneWidget);
        expect(find.text('Pectoralis Minor'), findsOneWidget);
        expect(find.text('Deltoid'), findsOneWidget);
      });
    });

    testWidgets('renders empty grid when muscles list is empty',
        (tester) async {
      await tester.pumpWidget(
        makeTestableSliver(
          const WorkoutsGridData(muscles: <MuscleEntity>[]),
        ),
      );

      expect(find.byType(MuscleCard), findsNothing);
    });

    testWidgets('handles muscle without image gracefully', (tester) async {
      await mockNetworkImagesFor(() async {
        const muscleNoImage = [MuscleEntity(id: 'x', name: 'Bicep')];
        await tester.pumpWidget(
          makeTestableSliver(const WorkoutsGridData(muscles: muscleNoImage)),
        );

        expect(find.byType(MuscleCard), findsOneWidget);
        expect(find.text('Bicep'), findsOneWidget);
      });
    });
  });
}
