import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/home_meals/home_food_card.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('HomeFoodCategoryCard 100% Coverage Tests', () {
    const String testTitle = 'Breakfast';
    const String testImageUrl = 'https://example.com/image.jpg';

    Widget createWidget({
      required VoidCallback onTap,
      String imageUrl = testImageUrl,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: HomeFoodCategoryCard(
            title: testTitle,
            imageUrl: imageUrl,
            onTap: onTap,
          ),
        ),
      );
    }

    testWidgets('1. Should render title and image correctly', (tester) async {
      await tester.pumpWidget(createWidget(onTap: () {}));

      expect(find.text(testTitle), findsOneWidget);

      expect(find.byType(CachedNetworkImage), findsOneWidget);

      expect(find.byType(SharedContainer), findsOneWidget);
    });

    testWidgets('2. Should trigger onTap when card is pressed', (tester) async {
      bool isTapped = false;
      await tester.pumpWidget(createWidget(onTap: () => isTapped = true));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(isTapped, isTrue);
    });

    testWidgets('3. Should cover CachedNetworkImage placeholder (Shimmer)', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(onTap: () {}));

      final imageFinder = find.byType(CachedNetworkImage);
      final cachedImage = tester.widget<CachedNetworkImage>(imageFinder);

      final placeholderWidget = cachedImage.placeholder!(
        tester.element(imageFinder),
        testImageUrl,
      );

      await tester.pumpWidget(MaterialApp(home: placeholderWidget));
      expect(find.byType(Shimmer), findsOneWidget);
    });

  });
}
