import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/random_muscle_section.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
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

  final mockMuscles = [
    RandomMusclesEntity(
      id: 'r1',
      name: 'Triceps',
      image: 'https://test.com/tricep.png',
    ),
    RandomMusclesEntity(
      id: 'r2',
      name: 'Back',
      image: 'https://test.com/back.png',
    ),
  ];

  Widget createWidgetUnderTest(BaseResponse<HomeSection>? response) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: Scaffold(body: RandomMusclesSection(response: response)),
      ),
    );
  }

  group('RandomMusclesSection Coverage Tests', () {
    testWidgets('1. Should show Shimmer when response is null (Loading)', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(null));
      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('2. Should show error message when response is ErrorResponse', (
      tester,
    ) async {
      const errorMsg = 'Error loading muscles';
      await tester.pumpWidget(
        createWidgetUnderTest(ErrorResponse(errorMessage: errorMsg)),
      );
      await tester.pump();

      expect(find.text(errorMsg), findsOneWidget);
    });

    testWidgets('3. Should render SharedCards when data is successful', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            SuccessResponse(data: RandomMuscleSection(mockMuscles)),
          ),
        );
        await tester.pump();

        expect(find.text('Triceps'), findsOneWidget);
        expect(find.text('Back'), findsOneWidget);
        expect(find.byType(SharedCard), findsNWidgets(2));
      });
    });

    testWidgets('4. Should Navigate when a muscle card is tapped', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            SuccessResponse(data: RandomMuscleSection(mockMuscles)),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('Triceps'));
        await tester.pump();

        verify(
          () => mockRouter.pushNamed(
            Routes.exercisesName,
            extra: any(named: 'extra'),
          ),
        ).called(1);
      });
    });

    testWidgets('5. Should return empty SizedBox when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(SuccessResponse(data: RandomMuscleSection([]))),
      );
      await tester.pump();

      expect(find.byType(SharedCard), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });
  });
}
