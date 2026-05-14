import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:fitness_app/Features/food/presentation/views/widgets/meal_image.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'meal_image_test.mocks.dart';

abstract class UrlLauncherPlatformMock extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {}

@GenerateMocks([UrlLauncherPlatformMock])
void main() {
  late MockUrlLauncherPlatformMock mockLauncher;

  setUpAll(() {
     HttpOverrides.global = _MockHttpOverrides();
  });

  setUp(() {
    mockLauncher = MockUrlLauncherPlatformMock();
    UrlLauncherPlatform.instance = mockLauncher;
  });

  Widget createWidgetUnderTest(String? url) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: MealImage(videoUrl: url),
      ),
    );
  }

  group('MealImage Widget Tests', () {
    const testYoutubeUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";

    testWidgets('should open video url on tap', (WidgetTester tester) async {
       when(mockLauncher.canLaunch(any)).thenAnswer((_) async => true);
      when(mockLauncher.launchUrl(any, any)).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest(testYoutubeUrl));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

       verify(mockLauncher.launchUrl(testYoutubeUrl, any)).called(1);
    });

    testWidgets('should show error snack bar when cannot launch', (WidgetTester tester) async {
      when(mockLauncher.canLaunch(any)).thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(testYoutubeUrl));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

 class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeMockHttpClient();
}

class _FakeMockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeMockHttpClientRequest();
}

class _FakeMockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeMockHttpClientResponse();
  @override
  HttpHeaders get headers => _FakeMockHttpHeaders();
}

class _FakeMockHttpClientResponse extends Mock implements HttpClientResponse {
  final Uint8List transparentPixel = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
    0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
    0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
    0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
    0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
    0x60, 0x82,
  ]);

  @override int get statusCode => 200;
  @override int get contentLength => transparentPixel.length;
  @override HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([transparentPixel]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class _FakeMockHttpHeaders extends Mock implements HttpHeaders {}