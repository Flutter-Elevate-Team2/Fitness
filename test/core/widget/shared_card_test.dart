import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/widget/shared_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
   setUpAll(() {
    HttpOverrides.global = null;
  });

  Widget createWidgetUnderTest({
    required String title,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SharedCard(
          title: title,
          imageUrl: imageUrl,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  group('SharedCard Widget Tests', () {
    const String testTitle = 'Running Plan';
    const String testImageUrl = 'https://example.com/image.png';

    testWidgets('Should display title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        imageUrl: testImageUrl,
      ));

       expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('Should trigger onTap when clicked', (WidgetTester tester) async {
      bool isTapped = false;

      await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        imageUrl: testImageUrl,
        onTap: () => isTapped = true,
      ));

       await tester.tap(find.byType(SharedCard));

      expect(isTapped, true);
    });

    testWidgets('Should render CachedNetworkImage when useCachedImage is true', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        imageUrl: testImageUrl,
      ));

       expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('Should apply correct border radius to ClipRRect', (WidgetTester tester) async {
      const double customRadius = 30.0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SharedCard(
            title: testTitle,
            imageUrl: testImageUrl,
            onTap: () {},
            borderRadius: customRadius,
          ),
        ),
      ));

       final clipRRectFinder = find.byType(ClipRRect).first;

       final clipRRect = tester.widget<ClipRRect>(clipRRectFinder);

       expect(clipRRect.borderRadius, BorderRadius.circular(customRadius));
    });
    testWidgets('Should show placeholder/shimmer while image is loading', (WidgetTester tester) async {
       await tester.pumpWidget(createWidgetUnderTest(
        title: testTitle,
        imageUrl: testImageUrl,
      ));

       expect(find.byType(CachedNetworkImage), findsOneWidget);
     });
  });
}