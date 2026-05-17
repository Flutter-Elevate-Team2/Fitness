import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_icon_button.dart';

void main() {
  group('SocialIconButton', () {
    testWidgets('renders an Image widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialIconButton(
              assetPath: 'assets/icons/Google.png',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialIconButton(
              assetPath: 'assets/icons/Google.png',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('does not crash when onTap is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SocialIconButton(
              assetPath: 'assets/icons/Google.png',
            ),
          ),
        ),
      );

      // Just verify it renders without crashing
      expect(find.byType(SocialIconButton), findsOneWidget);
    });

    testWidgets('has a 48x48 container', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialIconButton(
              assetPath: 'assets/icons/Apple.png',
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 48);
      expect(container.constraints?.maxHeight, 48);
    });
  });
}
