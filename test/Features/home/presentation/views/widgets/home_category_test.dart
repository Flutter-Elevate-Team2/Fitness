import 'package:fitness_app/Features/home/presentation/views/widgets/home_category.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest({
    void Function({String? selectedGroupId})? onTapGym,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: CategorySection(onTapGym: onTapGym)),
    );
  }

  group('CategorySection Coverage Tests', () {
    testWidgets('1. Should render category title and all 4 items', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Category'), findsOneWidget);
      expect(find.byType(InkWell), findsNWidgets(4));
      expect(find.byType(Image), findsNWidgets(4));
    });

    testWidgets(
      '2. Should display exactly 3 vertical dividers between 4 items',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final dividers = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints?.maxWidth == 1 &&
              widget.constraints?.maxHeight == 45,
        );

        expect(dividers, findsNWidgets(3));
      },
    );

    testWidgets('3. Should call onTapGym when Gym category is tapped', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(onTapGym: ({selectedGroupId}) => tapped = true),
      );

      await tester.tap(find.text('Gym'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets(
      '4. Should show "Coming Soon" overlay when unavailable item is tapped',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final yogaItem = find.ancestor(
          of: find.textContaining('Yoga'),
          matching: find.byType(InkWell),
        );

        await tester.tap(yogaItem);

        await tester.pump();

        await tester.pump(const Duration(milliseconds: 100));

        final overlayFinder = find.byType(SharedContainer, skipOffstage: false);
        expect(overlayFinder, findsOneWidget);

        expect(
          find.descendant(of: overlayFinder, matching: find.byType(Text)),
          findsOneWidget,
        );

        await tester.pump(const Duration(seconds: 2));

        expect(find.byType(SharedContainer), findsNothing);
      },
    );

    testWidgets('5. Should handle Trainer navigation tap', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Trainer'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('6. TrianglePainter should not repaint', (tester) async {
      final painter = TrianglePainter();
      expect(painter.shouldRepaint(painter), false);
    });
  });
}
