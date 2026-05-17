import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/grid/workouts_grid_data.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/muscle_card.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

 @GenerateMocks([GoRouter])
import 'workouts_grid_data_test.mocks.dart';

void main() {
   final mockMuscles = [
    const MuscleEntity(id: '1', name: 'Chest', image: 'chest.png'),
    const MuscleEntity(id: '2', name: 'Back', image: 'back.png'),
  ];

  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
  });

   Widget createWidgetUnderTest() {
     return MaterialApp(
       home: InheritedGoRouter(
         goRouter: mockRouter,
          child: Scaffold(
           body: CustomScrollView(
             slivers: [
               WorkoutsGridData(muscles: mockMuscles),
             ],
           ),
         ),
       ),
     );
   }

  group('WorkoutsGridData Tests', () {
    testWidgets('should render the correct number of muscle cards', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(MuscleCard), findsNWidgets(2));
      expect(find.text('Chest'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should navigate with correct data when a card is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      when(mockRouter.pushNamed(
        any,
        pathParameters: anyNamed('pathParameters'),
        queryParameters: anyNamed('queryParameters'),
        extra: anyNamed('extra'),
      )).thenAnswer((_) async => null);

      await tester.tap(find.text('Chest'));

       await tester.pump();

       verify(mockRouter.pushNamed(
        Routes.exercisesName,
         pathParameters: anyNamed('pathParameters'),
        queryParameters: anyNamed('queryParameters'),
        extra: {
          'primeMoverMuscleId': '1',
          'title': 'Chest',
          'image': 'chest.png',
        },
      )).called(1);
    });  });
}