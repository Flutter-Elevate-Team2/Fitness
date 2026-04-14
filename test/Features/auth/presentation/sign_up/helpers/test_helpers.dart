import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Wraps a widget in a MaterialApp with localization support for testing.
/// This is needed because many sign-up widgets use `context.l10n`.
Widget createTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: child),
  );
}

/// Same as [createTestableWidget] but does NOT wrap in a Scaffold,
/// useful for widgets that already contain their own Scaffold.
Widget createTestableWidgetNoScaffold(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: child,
  );
}
