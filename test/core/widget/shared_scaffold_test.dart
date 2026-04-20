import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithNavigator(Widget widget) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget),
            ),
            child: const Text('Go'),
          ),
        ),
      ),
    );
  }

  group('SharedScaffold Coverage Tests', () {
    testWidgets(
      'should hide Custom AppBar when title is null and showBackButton is false',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SharedScaffold(
              title: null,
              showBackButton: false,
              body: SizedBox(),
            ),
          ),
        );

        final appBarContainer = find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.minHeight == 56,
        );

        expect(appBarContainer, findsNothing);
      },
    );

    testWidgets(
      'should show Custom AppBar with title and back button by default',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SharedScaffold(title: Text('My Title'), body: SizedBox()),
          ),
        );

        expect(find.text('My Title'), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget); // زرار الرجوع
      },
    );

    testWidgets('should navigate back when back button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithNavigator(const SharedScaffold(body: Text('Page 2'))),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(find.text('Page 2'), findsNothing);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets(
      'should render background and foreground images when provided',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SharedScaffold(
              backgroundImage: 'assets/images/auth_background.png',
              foregroundImage: 'assets/images/app_icon.png',
              body: SizedBox(),
            ),
          ),
        );

        expect(find.byType(Image), findsNWidgets(2));
      },
    );

    testWidgets('should render body inside Expanded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SharedScaffold(body: Text('Body Content'))),
      );

      expect(
        find.ancestor(
          of: find.text('Body Content'),
          matching: find.byType(Expanded),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'should not show back button when showBackButton is false but title exists',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SharedScaffold(
              title: Text('Title Only'),
              showBackButton: false,
              body: SizedBox(),
            ),
          ),
        );

        expect(find.text('Title Only'), findsOneWidget);
        expect(find.byType(GestureDetector), findsNothing);
      },
    );
  });
}
