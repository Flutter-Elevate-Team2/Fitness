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
      'should hide AppBar when title is null and showBackButton is false',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SharedScaffold(
              title: null,
              showBackButton: false,
              body: const SizedBox(),
            ),
          ),
        );

        expect(find.byType(AppBar), findsNothing);
      },
    );

    testWidgets('should show AppBar with title and back button by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SharedScaffold(
            title: const Text('My Title'),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('My Title'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

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
        FlutterError.onError = null;

        await tester.pumpWidget(
          MaterialApp(
            home: SharedScaffold(
              backgroundImage: 'assets/bg.png',
              foregroundImage: 'assets/fg.png',
              foregroundImageHeight: 200,
              foregroundImageTop: 50,
              body: const SizedBox(),
            ),
          ),
        );

        expect(find.byType(Image), findsNWidgets(2));

        final images = tester.widgetList<Image>(find.byType(Image)).toList();

        expect((images[0].image as AssetImage).assetName, 'assets/bg.png');
        expect(images[0].fit, BoxFit.cover);

        expect((images[1].image as AssetImage).assetName, 'assets/fg.png');
        expect(images[1].height, 200);
      },
    );

    testWidgets(
      'should use default height and top for foreground image when null',
      (tester) async {
        FlutterError.onError = null;

        await tester.pumpWidget(
          MaterialApp(
            home: SharedScaffold(
              foregroundImage: 'assets/fg.png',
              body: const SizedBox(),
            ),
          ),
        );

        final Positioned positioned = tester.widget(
          find
              .ancestor(
                of: find.byWidgetPredicate(
                  (widget) =>
                      widget is Image &&
                      (widget.image as AssetImage).assetName == 'assets/fg.png',
                ),
                matching: find.byType(Positioned),
              )
              .first,
        );

        expect(positioned.top, isNotNull);
      },
    );

    testWidgets('should render body inside SafeArea', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SharedScaffold(body: const Text('Body Content'))),
      );

      expect(
        find.ancestor(
          of: find.text('Body Content'),
          matching: find.byType(SafeArea),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'should not show back button when showBackButton is false but title exists',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SharedScaffold(
              title: const Text('Title Only'),
              showBackButton: false,
              body: const SizedBox(),
            ),
          ),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(GestureDetector), findsNothing);
      },
    );
  });
}
