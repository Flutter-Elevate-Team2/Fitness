import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_events.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/workouts_screen.dart';
 import 'package:fitness_app/Features/workouts/presentation/views/widgets/workouts_screen_body.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

 @GenerateMocks([WorkoutsViewModel])
import 'workouts_screen_test.mocks.dart';

void main() {
  late MockWorkoutsViewModel mockViewModel;

  setUp(() async {
    mockViewModel = MockWorkoutsViewModel();

     await getIt.reset();

     getIt.registerFactory<WorkoutsViewModel>(() => mockViewModel);

     when(mockViewModel.state).thenReturn(WorkoutsStates());
    when(mockViewModel.stream).thenAnswer((_) => Stream.value(  WorkoutsStates()));
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('should provide WorkoutsViewModel and add FetchMuscleGroupsEvent on init', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutsScreen(),
      ),
    );

    // Assert
     verify(mockViewModel.doIntent(argThat(isA<FetchMuscleGroupsEvent>()))).called(1);

    // Verify that the screen body is present
    expect(find.byType(WorkoutsScreenBody), findsOneWidget);
  });

  testWidgets('should pass initialGroupId to WorkoutsScreenBody', (WidgetTester tester) async {
    const String tGroupId = 'group_123';

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutsScreen(initialGroupId: tGroupId),
      ),
    );

    // Assert
    final bodyFinder = find.byType(WorkoutsScreenBody);
    final WorkoutsScreenBody bodyWidget = tester.widget(bodyFinder);

    expect(bodyWidget.initialGroupId, tGroupId);
  });

  testWidgets('should dispose ViewModel when screen is removed', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutsScreen(),
      ),
    );

     await tester.pumpWidget(const MaterialApp(home: Scaffold()));

     verify(mockViewModel.close()).called(1);
  });
}