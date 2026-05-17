import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/upcoming_workouts_section.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class MockHomeViewModel extends Mock implements HomeViewModel {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockHomeViewModel mockViewModel;
  late MockGoRouter mockRouter;

  setUp(() {
    mockViewModel = MockHomeViewModel();
    mockRouter = MockGoRouter();
    registerFallbackValue(const Object());

    when(() => mockViewModel.state).thenReturn(const HomeState());
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());

    when(
      () => mockRouter.pushNamed(any(), extra: any(named: 'extra')),
    ).thenAnswer((_) async => null);
  });

  final mockMuscleGroups = [
    MuscleGroupEntity(id: 'g1', name: 'Chest'),
    MuscleGroupEntity(id: 'g2', name: 'Back'),
  ];
  final mockMuscles = [
    MuscleEntity(
      id: 'm1',
      name: 'Bench Press',
      image: 'https://test.com/img.png',
    ),
  ];

  final successData = UpcomingWorkoutsSectionData(
    muscleGroups: mockMuscleGroups,
    currentGroupMuscles: mockMuscles,
    selectedGroupId: 'g1',
  );

  Widget createWidgetUnderTest({
    BaseResponse<HomeSection>? response,
    void Function({String? selectedGroupId})? onSeeAllTapped,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: BlocProvider<HomeViewModel>.value(
          value: mockViewModel,
          child: Scaffold(
            body: UpcomingWorkoutsSection(
              response: response,
              onSeeAllTapped: onSeeAllTapped,
            ),
          ),
        ),
      ),
    );
  }

  group('UpcomingWorkoutsSection 100% Coverage', () {
    testWidgets('1. Should show Shimmer (Tabs & Cards) when response is null', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(response: null));
      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('2. Should show Error message when response is ErrorResponse', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          response: ErrorResponse(errorMessage: 'Loading Failed'),
        ),
      );
      expect(find.text('Loading Failed'), findsOneWidget);
    });

    testWidgets(
      '3. Should call onSeeAllTapped with correct ID when See All is pressed',
      (tester) async {
        String? tappedId;
        await tester.pumpWidget(
          createWidgetUnderTest(
            response: SuccessResponse(data: successData),
            onSeeAllTapped: ({selectedGroupId}) => tappedId = selectedGroupId,
          ),
        );

        await tester.tap(find.text('See All'));
        expect(tappedId, 'g1');
      },
    );

    testWidgets(
      '4. Should call changeMuscleGroup on ViewModel when a Tab is tapped',
      (tester) async {
        final successData = UpcomingWorkoutsSectionData(
          muscleGroups: [
            MuscleGroupEntity(id: 'g1', name: 'Chest'),
            MuscleGroupEntity(id: 'g2', name: 'Back'),
          ],
          currentGroupMuscles: [],
          selectedGroupId: 'g1',
        );

        when(
          () => mockViewModel.changeMuscleGroup(any()),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          createWidgetUnderTest(response: SuccessResponse(data: successData)),
        );

        await tester.tap(find.text('Back'));
        await tester.pump();

        verify(() => mockViewModel.changeMuscleGroup('g2')).called(1);
      },
    );

    testWidgets(
      '5. Should render Muscles and navigate when SharedCard is tapped',
      (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(
            createWidgetUnderTest(response: SuccessResponse(data: successData)),
          );
          await tester.pump();

          expect(find.text('Bench Press'), findsOneWidget);

          await tester.tap(find.byType(SharedCard));
          verify(
            () => mockRouter.pushNamed(
              Routes.exercisesName,
              extra: any(named: 'extra'),
            ),
          ).called(1);
        });
      },
    );

    testWidgets(
      '6. Should show Cards Shimmer when currentGroupMuscles is empty',
      (tester) async {
        final emptyMusclesData = UpcomingWorkoutsSectionData(
          muscleGroups: mockMuscleGroups,
          currentGroupMuscles: [],
          selectedGroupId: 'g1',
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            response: SuccessResponse(data: emptyMusclesData),
          ),
        );

        expect(find.byType(Shimmer), findsWidgets);
      },
    );
  });
}
