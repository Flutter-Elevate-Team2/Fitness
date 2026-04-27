import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/home_meals/recommendation_section.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';

@GenerateNiceMocks([MockSpec<HomeViewModel>(), MockSpec<GoRouter>()])
import 'recommendation_section_test.mocks.dart';

void main() {
  late MockHomeViewModel mockViewModel;
  late MockGoRouter mockRouter;

  setUp(() {
    mockViewModel = MockHomeViewModel();
    mockRouter = MockGoRouter();

    // Standard stream stub for BLoCs
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Wrap with InheritedGoRouter so context.pushNamed works
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: Scaffold(
          body: BlocProvider<HomeViewModel>.value(
            value: mockViewModel,
            child: const RecommendationForYouSection(),
          ),
        ),
      ),
    );
  }

  group('RecommendationForYouSection Logic Coverage', () {
    testWidgets('1. Should show Loading Indicator when isLoading is true', (tester) async {
      when(mockViewModel.state).thenReturn(
        const HomeState(isLoading: true, foodCategories: []),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('2. Should render list of categories when data is available', (tester) async {
      final testCategories = [
        CategoryEntity(name: 'Breakfast', image: 'url1', id: '1', description: 'desc'),
      ];

      when(mockViewModel.state).thenReturn(
        HomeState(isLoading: false, foodCategories: testCategories),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Breakfast'), findsOneWidget);
    });

    testWidgets('3. Should Navigate when a Category Card is tapped', (tester) async {
      final testCategories = [
        CategoryEntity(name: 'Breakfast', image: 'url1', id: '1', description: 'desc'),
      ];

      when(mockViewModel.state).thenReturn(
        HomeState(isLoading: false, foodCategories: testCategories),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text('Breakfast'));
      // Changed pumpAndSettle to pump
      await tester.pump();

      verify(
        mockRouter.pushNamed(
          Routes.mealsName,
          extra: anyNamed('extra'),
        ),
      ).called(1);
    });

    testWidgets('4. TextButton (See All) - Success Case', (tester) async {
      final testCategories = [
        CategoryEntity(name: 'Breakfast', image: 'url1', id: '1', description: 'desc'),
      ];

      when(mockViewModel.state).thenReturn(
        HomeState(isLoading: false, foodCategories: testCategories),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final btn = find.byType(TextButton);
      await tester.tap(btn);
      // Changed pumpAndSettle to pump
      await tester.pump();

      verify(
        mockRouter.pushNamed(
          Routes.mealsName,
          extra: anyNamed('extra'),
        ),
      ).called(1);
    });
    testWidgets('5. TextButton (See All) - Return early when Empty', (tester) async {
      when(mockViewModel.state).thenReturn(
        const HomeState(isLoading: false, foodCategories: []),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      verifyNever(mockRouter.pushNamed(any, extra: anyNamed('extra')));
    });
  });
}