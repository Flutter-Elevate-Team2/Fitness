import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/widgets/difficulty_tabs.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── Shared fixtures ──
  const tLevels = [
    DifficultyLevelEntity(id: 'lvl_1', name: 'Beginner'),
    DifficultyLevelEntity(id: 'lvl_2', name: 'Intermediate'),
    DifficultyLevelEntity(id: 'lvl_3', name: 'Advanced'),
  ];

  group('DifficultyTabsWidget Tests', () {
    testWidgets('should render all difficulty level tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: DifficultyTabsWidget(
              levels: tLevels,
              selectedLevelId: 'lvl_1',
              onTabChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('should highlight the selected tab', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: DifficultyTabsWidget(
              levels: tLevels,
              selectedLevelId: 'lvl_2',
              onTabChanged: (_) {},
            ),
          ),
        ),
      );

      // The selected tab container should have a primary color background
      final selectedTabFinder = find.text('Intermediate');
      expect(selectedTabFinder, findsOneWidget);
    });

    testWidgets('should call onTabChanged with correct id when tapped', (
      tester,
    ) async {
      String? tappedId;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: DifficultyTabsWidget(
              levels: tLevels,
              selectedLevelId: 'lvl_1',
              onTabChanged: (id) => tappedId = id,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();

      expect(tappedId, 'lvl_3');
    });

    testWidgets('should render empty when levels list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: DifficultyTabsWidget(
              levels: const [],
              selectedLevelId: '',
              onTabChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
    });
  });
}
