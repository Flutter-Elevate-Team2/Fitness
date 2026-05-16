import 'package:fitness_app/Features/food/presentation/views/widgets/meal_image.dart';
 import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

void main() {
  const MethodChannel connectivityChannel = MethodChannel('dev.fluttercommunity.plus/connectivity');

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();


     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'check') return ['wifi'];
      return null;
    });
  });

  Widget createWidgetUnderTest(String? url) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: MealImage(videoUrl: url, title: "Meal Video"),
      ),
    );
  }

  group('MealImage Widget Tests', () {
    const testUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";

    testWidgets('should display play icon', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest(testUrl));
        await tester.pump();
        expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      });
    });

  });
}