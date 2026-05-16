// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/web_view_screen.dart';

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
  MockPlatformWebViewController(super.params)
      : super.implementation();

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}
}

class MockPlatformWebViewWidget extends PlatformWebViewWidget {
  MockPlatformWebViewWidget(super.params)
      : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  setUpAll(() {
    WebViewPlatform.instance = MockWebViewPlatform();
  });

  group('WebViewScreen Widget Tests', () {
    const String tUrl = 'https://flutter.dev';
    const String tTitle = 'Terms of Service';

    testWidgets('Should display the correct title in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WebViewScreen(url: tUrl, title: tTitle),
        ),
      );

      expect(find.text(tTitle), findsOneWidget);
    });

    testWidgets('Should contain WebViewWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WebViewScreen(url: tUrl, title: tTitle),
        ),
      );

      expect(find.byType(WebViewWidget), findsOneWidget);
    });
  });
}