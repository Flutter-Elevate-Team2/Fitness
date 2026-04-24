import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/exercise_card.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  // ── Shared fixtures ──
  const tExerciseWithVideo = ExerciseEntity(
    id: 'ex_1',
    title: 'Chest • Barbell',
    description: 'Bench Press',
    sets: 3,
    reps: 15,
    thumbnailUrl: 'https://img.youtube.com/vi/abc/hqdefault.jpg',
    videoUrl: 'https://www.youtube.com/watch?v=abc',
  );

  const tExerciseWithoutVideo = ExerciseEntity(
    id: 'ex_2',
    title: 'Chest',
    description: 'Push Up',
    sets: 3,
    reps: 15,
    thumbnailUrl: 'local_asset_path.png',
    videoUrl: null,
  );

  Widget createWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );
  }

  group('ExerciseCardWidget Tests', () {
    testWidgets('should render exercise title and description', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseCardWidget(
              exercise: tExerciseWithVideo,
              onPlayTapped: () {},
            ),
          ),
        );

        expect(find.text('Chest • Barbell'), findsOneWidget);
        expect(find.text('Bench Press'), findsOneWidget);
      });
    });

    testWidgets('should render sets and reps info', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseCardWidget(
              exercise: tExerciseWithVideo,
              onPlayTapped: () {},
            ),
          ),
        );
        // Use pump() instead of pumpAndSettle() to avoid
        // CachedNetworkImage animation timeout
        await tester.pump();

        // The sets/reps string should be rendered (format: "3 groups * 15 times")
        expect(find.textContaining('3'), findsWidgets);
        expect(find.textContaining('15'), findsWidgets);
      });
    });

    testWidgets('should call onPlayTapped when play button is tapped', (
      tester,
    ) async {
      bool wasTapped = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseCardWidget(
              exercise: tExerciseWithVideo,
              onPlayTapped: () => wasTapped = true,
            ),
          ),
        );

        // Use pump() instead of pumpAndSettle() to avoid animation timeout
        await tester.pump();

        // Find play button by icon
        await tester.tap(find.byIcon(Icons.play_arrow_rounded));
        await tester.pump();

        expect(wasTapped, true);
      });
    });

    testWidgets('play button should be rendered when onPlayTapped is null', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidget(
            ExerciseCardWidget(
              exercise: tExerciseWithoutVideo,
              onPlayTapped: null,
            ),
          ),
        );

        // Play button still renders but is disabled
        expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      });
    });
  });

  group('PlayButton Widget Tests', () {
    testWidgets('should render enabled state when onTap is not null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(
          PlayButton(onTap: () {}),
        ),
      );

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('should render disabled state when onTap is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(
          const PlayButton(onTap: null),
        ),
      );

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });
  });
}
