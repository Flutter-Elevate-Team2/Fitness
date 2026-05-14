import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
 import 'package:fitness_app/core/widget/shared_container.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: ChangePasswordShimmer(),
      ),
    );
  }

  group('ChangePasswordShimmer Tests', () {

    testWidgets('should render ChangePasswordShimmer without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(ChangePasswordShimmer), findsOneWidget);
    });

    testWidgets('should contain Shimmer widgets', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Shimmer), findsAtLeastNWidgets(1));
    });

    testWidgets('should render the SharedContainer for settings', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(SharedContainer), findsOneWidget);
    });

    testWidgets('should render exactly 3 rows in the settings container list', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

     final rowFinder = find.descendant(
        of: find.byType(SharedContainer),
        matching: find.byType(Row),
      );

      expect(rowFinder, findsNWidgets(3));
    });

    testWidgets('should check for safe area and scrollview presence', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}