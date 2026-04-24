import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/screens/meals/meals_screen.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/category_tabs.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/meal_grids.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meals_screen_test.mocks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([MealsViewModel])
void main() {
  late MockMealsViewModel mockViewModel;
  final List<String> testCategories = ['Beef', 'Chicken'];
  const String initialCat = 'Beef';

  setUp(() {
    mockViewModel = MockMealsViewModel();
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.state).thenReturn(MealsState());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<MealsViewModel>.value(
        value: mockViewModel,
        child: MealsScreen(
          selectedCategory: initialCat,
          categories: testCategories,
        ),
      ),
    );
  }

  group('MealsScreen Absolute 100% Coverage', () {
    testWidgets('Verify initState, Build, and Scaffold Properties', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      verify(
        mockViewModel.doIntent(argThat(isA<FetchMealsByCategoryEvent>())),
      ).called(1);

      final scaffoldFinder = find.byType(SharedScaffold);
      expect(scaffoldFinder, findsOneWidget);

      final scaffoldWidget = tester.widget<SharedScaffold>(scaffoldFinder);
      expect(scaffoldWidget.showBackButton, true);
      expect(
        scaffoldWidget.backgroundImage,
        Assets.images.food.path,
      );

      final titleText = scaffoldWidget.title as Text;
      expect(titleText.style?.color, isNotNull);

      expect(find.byType(CategoryTabsWidget), findsOneWidget);
      expect(find.byType(MealsGridWidget), findsOneWidget);
      expect(find.byType(Expanded), findsAtLeastNWidgets(1));
    });

    testWidgets('Verify correctly passed widget categories', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final tabs = tester.widget<CategoryTabsWidget>(
        find.byType(CategoryTabsWidget),
      );
      expect(tabs.initialCategory, initialCat);
      expect(tabs.categories, testCategories);
    });
  });
}
