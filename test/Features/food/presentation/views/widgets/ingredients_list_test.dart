import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/ingredients_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
   final List<IngredientEntity> testIngredients = [
    IngredientEntity(name: 'Chicken', measure: '500g'),
    IngredientEntity(name: 'Garlic', measure: '2 cloves'),
    IngredientEntity(name: 'Olive Oil', measure: '2 tbsp'),
  ];

  Widget createWidgetUnderTest(List<IngredientEntity> ingredients) {
    return MaterialApp(
      home: Scaffold(
        body: IngredientsList(ingredients: ingredients),
      ),
    );
  }

  group('IngredientsList Widget Tests', () {

    testWidgets('should render the correct number of ingredient items',
            (WidgetTester tester) async {
           await tester.pumpWidget(createWidgetUnderTest(testIngredients));

           expect(find.text('Chicken'), findsOneWidget);
          expect(find.text('Garlic'), findsOneWidget);
          expect(find.text('Olive Oil'), findsOneWidget);

           expect(find.text('500g'), findsOneWidget);
          expect(find.text('2 cloves'), findsOneWidget);
        });

    testWidgets('should render a Divider between items',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest(testIngredients));

        expect(find.byType(Divider), findsNWidgets(testIngredients.length - 1));
        });

    testWidgets('should handle empty ingredients list gracefully',
            (WidgetTester tester) async {
           await tester.pumpWidget(createWidgetUnderTest([]));

           expect(find.byType(Row), findsNothing);
          expect(find.byType(Divider), findsNothing);
        });

    testWidgets('should check text styling for ingredient names',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest(testIngredients));

           final nameText = tester.widget<Text>(find.text('Chicken'));

           expect(nameText.style?.color, equals(Colors.white));
         });
  });
}