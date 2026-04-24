import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/meal_card.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/meal_grids.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meal_grids_test.mocks.dart';

@GenerateMocks([MealsViewModel])
void main() {
  late MockMealsViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockMealsViewModel();
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<MealsViewModel>.value(
          value: mockViewModel,
          child: const MealsGridWidget(),
        ),
      ),
    );
  }

  group('MealsGridWidget Tests', () {
    testWidgets('1. Should show Loading Indicator when state is loading', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        MealsState().copyWith(
          mealsByCategoryState: const BaseState(isLoading: true),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('2. Should show Error Message when there is an error', (
      tester,
    ) async {
      const errorMsg = 'Failed to fetch meals';

      when(mockViewModel.state).thenReturn(
        MealsState().copyWith(
          mealsByCategoryState: const BaseState(errorMessage: errorMsg),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(errorMsg), findsOneWidget);
    });

    testWidgets(
      '3. Should render GridView with MealCards when data is loaded',
      (tester) async {
        final testMeals = [
          MealsByCategoryEntity(id: '1', name: 'Meal 1', image: 'url1'),
          MealsByCategoryEntity(id: '2', name: 'Meal 2', image: 'url2'),
        ];

        when(mockViewModel.state).thenReturn(
          MealsState().copyWith(
            mealsByCategoryState: BaseState(data: testMeals),
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(GridView), findsOneWidget);

        expect(find.byType(MealCard), findsNWidgets(testMeals.length));

        expect(find.text('Meal 1'), findsOneWidget);
        expect(find.text('Meal 2'), findsOneWidget);
      },
    );

    testWidgets('4. Should show empty list when data is null or empty', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        MealsState().copyWith(mealsByCategoryState: const BaseState(data: [])),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(MealCard), findsNothing);
    });

    testWidgets('5. Should execute onTap code when a MealCard is pressed', (
      tester,
    ) async {
      final testMeals = [
        MealsByCategoryEntity(id: '1', name: 'Meal 1', image: 'url1'),
      ];

      when(mockViewModel.state).thenReturn(
        MealsState().copyWith(mealsByCategoryState: BaseState(data: testMeals)),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(MealCard));
      await tester.pump();

      expect(find.byType(MealCard), findsOneWidget);
    });

    testWidgets('6. Should have correct GridView styling and configuration', (
      tester,
    ) async {
      final testMeals = [
        MealsByCategoryEntity(id: '1', name: 'Meal 1', image: 'url1'),
      ];

      when(mockViewModel.state).thenReturn(
        MealsState().copyWith(mealsByCategoryState: BaseState(data: testMeals)),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(gridView.padding, const EdgeInsets.all(16));
      expect(delegate.crossAxisCount, 2);
      expect(delegate.childAspectRatio, 0.9);
      expect(delegate.crossAxisSpacing, 16);
      expect(delegate.mainAxisSpacing, 16);
    });
  });
}
