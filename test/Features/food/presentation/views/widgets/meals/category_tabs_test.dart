import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/category_tabs.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_tabs_test.mocks.dart';

@GenerateMocks([MealsViewModel])
void main() {
  late MockMealsViewModel mockViewModel;
  final List<String> testCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Vegan',
  ];

  setUp(() {
    mockViewModel = MockMealsViewModel();

    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.state).thenReturn(MealsState());
  });

  Widget createWidgetUnderTest({String initial = 'Breakfast'}) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<MealsViewModel>.value(
          value: mockViewModel,
          child: CategoryTabsWidget(
            initialCategory: initial,
            categories: testCategories,
          ),
        ),
      ),
    );
  }

  group('CategoryTabsWidget Tests', () {
    testWidgets(
      '1. Should render all categories and highlight the initial one',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        for (var cat in testCategories) {
          expect(find.text(cat), findsOneWidget);
        }

        final initialContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('Breakfast'),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          (initialContainer.decoration as BoxDecoration).color,
          AppColors.primary,
        );
      },
    );

    testWidgets(
      '2. Should update selection and trigger FetchMealsByCategoryEvent on tap',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.text('Lunch'));
        await tester.pumpAndSettle();

        final lunchContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('Lunch'),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          (lunchContainer.decoration as BoxDecoration).color,
          AppColors.primary,
        );

        final breakfastContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('Breakfast'),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          (breakfastContainer.decoration as BoxDecoration).color,
          Colors.transparent,
        );

        verify(mockViewModel.doIntent(any)).called(1);
      },
    );

    testWidgets('3. Should scroll to selected category automatically on init', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(initial: 'Vegan'));
      await tester.pumpAndSettle();

      expect(find.text('Vegan'), findsOneWidget);

      final scrollable = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollable.controller?.hasClients, isTrue);
    });

    testWidgets(
      '4. Should handle edge case where initial category is at index 0',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(initial: 'Breakfast'));
        await tester.pumpAndSettle();

        final scrollable = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollable.controller?.offset, 0.0);
      },
    );
  });
}
