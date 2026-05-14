import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  group('ProfilePageShimmer Widget Tests', () {

    testWidgets('Should render ProfilePageShimmer correctly', (WidgetTester tester) async {
       await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePageShimmer(),
          ),
        ),
      );

       expect(find.byType(CircleAvatar), findsOneWidget);

     expect(find.byType(Shimmer), findsAtLeastNWidgets(3));

       expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Should render 6 rows in the settings container', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePageShimmer(),
          ),
        ),
      );

     final rowIconPlaceholders = find.byWidgetPredicate(
            (widget) => widget is Container && widget.constraints?.maxWidth == 24,
      );

      expect(rowIconPlaceholders, findsNWidgets(6));
    });
  });
}