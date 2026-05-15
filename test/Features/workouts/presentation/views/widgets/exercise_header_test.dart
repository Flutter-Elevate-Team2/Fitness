import 'package:fitness_app/Features/workouts/presentation/views/widgets/exercise_header.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  // ── Shared fixtures ──
  const tTitle = 'Chest Exercises';
  const tDescription = 'Build your chest muscles';
  const tTime = '30 MIN';
  const tCalories = '130 Cal';
  const tLocalImage = 'assets/images/exercises_background.png';
  const tNetworkImage = 'https://example.com/image.jpg';

  Widget createWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );
  }

  group('ExerciseHeaderWidget Tests', () {
    testWidgets('should render title and description', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseHeaderWidget(
              title: tTitle,
              description: tDescription,
              timeInMinutes: tTime,
              calories: tCalories,
              imageUrl: tLocalImage,
              onBackTapped: () {},
            ),
          ),
        );

        expect(find.text(tTitle), findsOneWidget);
        expect(find.text(tDescription), findsOneWidget);
      });
    });

    testWidgets('should render time and calories pills', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseHeaderWidget(
              title: tTitle,
              description: tDescription,
              timeInMinutes: tTime,
              calories: tCalories,
              imageUrl: tLocalImage,
              onBackTapped: () {},
            ),
          ),
        );

        expect(find.text(tTime), findsOneWidget);
        expect(find.text(tCalories), findsOneWidget);
      });
    });

    testWidgets('should call onBackTapped when back button is tapped', (
      tester,
    ) async {
      bool wasBackTapped = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseHeaderWidget(
              title: tTitle,
              description: tDescription,
              timeInMinutes: tTime,
              calories: tCalories,
              imageUrl: tLocalImage,
              onBackTapped: () => wasBackTapped = true,
            ),
          ),
        );

        // Back button uses keyboard_arrow_left_rounded icon
        await tester.tap(find.byIcon(Icons.keyboard_arrow_left_rounded));
        await tester.pumpAndSettle();

        expect(wasBackTapped, true);
      });
    });

    testWidgets('should render with network image URL', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseHeaderWidget(
              title: tTitle,
              description: tDescription,
              timeInMinutes: tTime,
              calories: tCalories,
              imageUrl: tNetworkImage,
              onBackTapped: () {},
            ),
          ),
        );

        // Should not crash and should render the header
        expect(find.text(tTitle), findsOneWidget);
      });
    });

    testWidgets('should render back button as a circle with arrow icon', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseHeaderWidget(
              title: tTitle,
              description: tDescription,
              timeInMinutes: tTime,
              calories: tCalories,
              imageUrl: tLocalImage,
              onBackTapped: () {},
            ),
          ),
        );

        expect(
          find.byIcon(Icons.keyboard_arrow_left_rounded),
          findsOneWidget,
        );
      });
    });
  });
}
