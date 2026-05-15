import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LocalizationExtension.l10n returns AppLocalizations', (
      tester,
      ) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(capturedContext.l10n, isA<AppLocalizations>());
  });
}
