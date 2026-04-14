import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_login_row.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_icon_button.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

void main() {
  group('SocialLoginRow', () {
    Widget buildWidget() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(body: SocialLoginRow()),
      );
    }

    testWidgets('displays the "Or" divider text',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.text('Or'), findsOneWidget);
    });

    testWidgets('renders three social icon buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SocialIconButton), findsNWidgets(3));
    });

    testWidgets('renders two dividers', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('renders three Image widgets for social icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNWidgets(3));
    });
  });
}
