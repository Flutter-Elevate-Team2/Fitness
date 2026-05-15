 import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
 import 'package:fitness_app/Features/food/presentation/views/screens/meal_details_screen.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meal_details_screen_body.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

 @GenerateMocks([MealsViewModel])
import 'meal_details_screen_test.mocks.dart';

void main() {
  late MockMealsViewModel mockMealsViewModel;
  const String testMealId = '52772';

  setUp(() {
    mockMealsViewModel = MockMealsViewModel();

    if (getIt.isRegistered<MealsViewModel>()) {
      getIt.unregister<MealsViewModel>();
    }
    getIt.registerFactory<MealsViewModel>(() => mockMealsViewModel);
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: MealDetailsScreen(testMealId),
    );
  }

  group('MealDetailsScreen Widget Tests', () {
    testWidgets('should display MealDetailsScreenBody and trigger fetch event on init',
            (WidgetTester tester) async {
           when(mockMealsViewModel.state).thenReturn(const MealsState());
          when(mockMealsViewModel.stream).thenAnswer((_) => Stream.value(const MealsState()));

           await tester.pumpWidget(createWidgetUnderTest());

           expect(find.byType(MealDetailsScreenBody), findsOneWidget);

           verify(mockMealsViewModel.doIntent(any)).called(1);
        });
  });
}