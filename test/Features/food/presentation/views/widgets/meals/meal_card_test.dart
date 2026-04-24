import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meals/meal_card.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('MealCard Widget Tests', () {
    const String testTitle = 'Grilled Chicken';
    const String testImageUrl = 'https://example.com/image.jpg';

    Widget createWidget(Widget child) =>
        MaterialApp(home: Scaffold(body: child));

    testWidgets('1. Full Image Flow (Including Placeholder and Success)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(const MealCard(title: testTitle, imageUrl: testImageUrl)),
      );

      expect(find.text(testTitle), findsOneWidget);
      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      final cachedImage = tester.widget<CachedNetworkImage>(imageFinder);
      final placeholderWidget = cachedImage.placeholder!(
        tester.element(imageFinder),
        testImageUrl,
      );

      await tester.pumpWidget(createWidget(placeholderWidget));
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('2. Error Widget Coverage', (tester) async {
      await tester.pumpWidget(
        createWidget(const MealCard(title: testTitle, imageUrl: testImageUrl)),
      );

      final imageFinder = find.byType(CachedNetworkImage);
      final cachedImage = tester.widget<CachedNetworkImage>(imageFinder);

      final errorWidget = cachedImage.errorWidget!(
        tester.element(imageFinder),
        testImageUrl,
        'error',
      );

      await tester.pumpWidget(createWidget(errorWidget));
      expect(find.byIcon(Icons.fastfood), findsOneWidget);
    });

    testWidgets('3. Empty URL Branch Coverage', (tester) async {
      await tester.pumpWidget(
        createWidget(const MealCard(title: testTitle, imageUrl: '')),
      );

      expect(find.byIcon(Icons.fastfood), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('4. Tap Interaction and Theme Coverage', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createWidget(
          MealCard(
            title: testTitle,
            imageUrl: testImageUrl,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);

      final textWidget = tester.widget<Text>(find.text(testTitle));
      expect(textWidget.style?.color, AppColors.white);
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('5. Decoration and Gradient Depth Coverage', (tester) async {
      await tester.pumpWidget(
        createWidget(const MealCard(title: testTitle, imageUrl: testImageUrl)),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MealCard),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16.0));

      final gradientFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient != null,
      );

      expect(gradientFinder, findsOneWidget);
      final gradientContainer = tester.widget<Container>(gradientFinder);
      final gradient =
          (gradientContainer.decoration as BoxDecoration).gradient
              as LinearGradient;

      expect(gradient.colors, [Colors.black87, Colors.transparent]);
      expect(gradient.stops, [0.0, 0.6]);
    });
  });
}
