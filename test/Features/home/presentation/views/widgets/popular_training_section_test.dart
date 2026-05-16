import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/popular_training_section.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
    registerFallbackValue(const Object());

    when(
      () => mockRouter.pushNamed(
        any(),
        pathParameters: any(named: 'pathParameters'),
        queryParameters: any(named: 'queryParameters'),
        extra: any(named: 'extra'),
      ),
    ).thenAnswer((_) async => null);
  });

  final mockWorkouts = [
    PopularWorkoutEntity(
      muscleId: 'm1',
      muscleName: 'Biceps',
      muscleImage: 'https://example.com/biceps.jpg',
      levelId: 'l1',
      levelName: 'Beginner',
      exercises: const [
        ExerciseEntity(
          id: 'e1',
          title: 'Curl',
          description: '',
          sets: 3,
          reps: 12,
          thumbnailUrl: '',
        ),
      ],
    ),
  ];

  Widget createWidgetUnderTest(BaseResponse<HomeSection>? response) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: Scaffold(body: PopularTrainingSection(response: response)),
      ),
    );
  }

  group('PopularTrainingSection Coverage Tests', () {
    testWidgets('1. Should show Shimmer when response is null (Loading)', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(null));
      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('2. Should show error message when response is ErrorResponse', (
      tester,
    ) async {
      const errorMsg = 'Failed to load workouts';
      await tester.pumpWidget(
        createWidgetUnderTest(ErrorResponse(errorMessage: errorMsg)),
      );
      await tester.pump();

      expect(find.text(errorMsg), findsOneWidget);
    });

    testWidgets('3. Should show "No workouts found" when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          SuccessResponse(data: PopularWorkoutsSection([])),
        ),
      );
      await tester.pump();

      expect(find.text("No workouts found"), findsOneWidget);
    });

    testWidgets('4. Should render workout cards correctly on Success', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            SuccessResponse(data: PopularWorkoutsSection(mockWorkouts)),
          ),
        );
        await tester.pump();

        expect(find.text('Biceps'), findsOneWidget);
        expect(find.text('Beginner'), findsOneWidget);
        expect(find.textContaining('Tasks'), findsOneWidget);
      });
    });

    testWidgets('5. Should Navigate to exercises when a card is tapped', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            SuccessResponse(data: PopularWorkoutsSection(mockWorkouts)),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('Biceps'));
        await tester.pump();

        verify(
          () => mockRouter.pushNamed(
            Routes.exercisesName,
            extra: any(named: 'extra'),
          ),
        ).called(1);
      });
    });
  });
}
