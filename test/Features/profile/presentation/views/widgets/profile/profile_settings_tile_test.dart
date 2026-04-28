import 'dart:convert';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_settings_tile.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Uint8List kTransparentImage = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  Widget createWidgetUnderTest({
    required String title,
    bool isLanguage = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

       locale: const Locale('en'),
      home: Scaffold(
        body: ProfileSettingsTile(
          icon: 'assets/icons/test.png',
          title: title,
          onTap: () {},
          isLanguage: isLanguage,
          switchValue: switchValue,
          onSwitchChanged: onSwitchChanged,
        ),
      ),
    );
  }

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String assetName = utf8.decode(message!.buffer.asUint8List());

       if (assetName.contains('AssetManifest')) {
         final Map<String, List<Object>> manifest = {};
        final ByteData data = const StandardMessageCodec().encodeMessage(manifest)!;
        return data;
      }

       return ByteData.view(kTransparentImage.buffer);
    });
  });
  group('ProfileSettingsTile Tests', () {

    testWidgets('renders title correctly when isLanguage is false', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(title: 'Notifications'));

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
       expect(find.byType(Switch), findsNothing);
    });

    testWidgets('shows Switch and specific text when isLanguage is true', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'Language',
        isLanguage: true,
        switchValue: true,
      ));

      expect(find.byType(Switch), findsOneWidget);

       final Switch switchWidget = tester.widget(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('calls onSwitchChanged when switch is toggled', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(createWidgetUnderTest(
        title: 'Language',
        isLanguage: true,
        onSwitchChanged: (val) => changedValue = val,
      ));

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(changedValue, isNotNull);
    });

    testWidgets('shows divider when isLast is false (default)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(title: 'Item'));
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}