// ignore_for_file: depend_on_referenced_packages, unnecessary_import, use_super_parameters

import 'dart:convert';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_settings_tile.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/web_view_screen.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

 class MockWebViewPlatform extends WebViewPlatform with MockPlatformInterfaceMixin {
  @override
  PlatformWebViewController createPlatformWebViewController(
      PlatformWebViewControllerCreationParams params,
      ) => MockPlatformWebViewController(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams params,
      ) => MockPlatformWebViewWidget(params);
}


class MockPlatformWebViewController extends PlatformWebViewController {
   MockPlatformWebViewController(PlatformWebViewControllerCreationParams params)
      : super.implementation(params);

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}
}

class MockPlatformWebViewWidget extends PlatformWebViewWidget {
   MockPlatformWebViewWidget(PlatformWebViewWidgetCreationParams params)
      : super.implementation(params);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
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
    bool isLast = false,
    String? webView,
    Function(bool)? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: ProfileSettingsTile(
          icon: 'assets/icons/test.png',
          title: title,
          onTap: onTap ?? () {},
          isLanguage: isLanguage,
          switchValue: switchValue,
          onSwitchChanged: onSwitchChanged,
          isLast: isLast,
          webView: webView,
        ),
      ),
    );
  }

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize Mock WebView Platform
    WebViewPlatform.instance = MockWebViewPlatform();

    // Mock Asset Bundle
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String assetName = utf8.decode(message!.buffer.asUint8List());
      if (assetName.contains('AssetManifest')) {
        final Map<String, List<Object>> manifest = {};
        return const StandardMessageCodec().encodeMessage(manifest);
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
      // It uses RichText for language, so we verify its presence
      expect(find.byType(RichText), findsOneWidget);
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

    testWidgets('hides divider when isLast is true', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(title: 'Item', isLast: true));
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('navigates to WebViewScreen when webView prop is provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'Privacy Policy',
        webView: 'privacy',
      ));

      // Tap the item
      await tester.tap(find.text('Privacy Policy'));
      // We need multiple pumps for navigation to complete
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Check if WebViewScreen is pushed onto the stack
      expect(find.byType(WebViewScreen), findsOneWidget);
      expect(find.text('Privacy Policy'), findsAtLeastNWidgets(1));
    });

    testWidgets('triggers onTap callback when webView is null', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'Simple Tile',
        onTap: () => tapped = true,
      ));

      await tester.tap(find.text('Simple Tile'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}