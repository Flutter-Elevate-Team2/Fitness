import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/home_meals/recommendation_section.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
    registerFallbackValue(const Object());

    when(() => mockRouter.pushNamed(
      any(),
      pathParameters: any(named: 'pathParameters'),
      queryParameters: any(named: 'queryParameters'),
      extra: any(named: 'extra'),
    )).thenAnswer((_) async => null);
  });

  Widget createWidgetUnderTest(BaseResponse<HomeSection>? response) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: Scaffold(body: RecommendationForYouSection(response: response)),
      ),
    );
  }

  final testCategories = [
    CategoryEntity(
      id: '1',
      name: 'Breakfast',
      image: 'url',
      description: 'desc',
    ),
    CategoryEntity(id: '2', name: 'Lunch', image: 'url', description: 'desc'),
  ];

  final successSection = FoodCategoriesSection(testCategories);

  group('RecommendationForYouSection Tests', () {
    testWidgets('1. Should show Shimmer when response is null (Loading)', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(null));

      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('2. Should show Error message when response is ErrorResponse', (
      tester,
    ) async {
      const errorMsg = 'Check your internet connection';
      await tester.pumpWidget(
        createWidgetUnderTest(ErrorResponse(errorMessage: errorMsg)),
      );

      expect(find.text(errorMsg), findsOneWidget);
    });

    testWidgets('3. Should render list of Category cards on Success', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(SuccessResponse(data: successSection)),
      );

      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.byType(SharedCard), findsNWidgets(2));
    });

    testWidgets('4. Should Navigate when "See All" is tapped', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(SuccessResponse(data: successSection)),
      );

      final seeAllButton = find.byType(TextButton);
      await tester.tap(seeAllButton);
      await tester.pump();

      verify(
        () =>
            mockRouter.pushNamed(Routes.mealsName, extra: any(named: 'extra')),
      ).called(1);
    });

    testWidgets('5. Should Navigate when a specific Category Card is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(SuccessResponse(data: successSection)),
      );

      await tester.tap(find.text('Breakfast'));
      await tester.pump();

      verify(
        () =>
            mockRouter.pushNamed(Routes.mealsName, extra: any(named: 'extra')),
      ).called(1);
    });

    testWidgets(
      '6. Should NOT navigate when "See All" is tapped and list is empty',
      (tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            SuccessResponse(data: FoodCategoriesSection([])),
          ),
        );

        await tester.tap(find.byType(TextButton));
        await tester.pump();

        verifyNever(
          () => mockRouter.pushNamed(any(), extra: any(named: 'extra')),
        );
      },
    );
  });
}
