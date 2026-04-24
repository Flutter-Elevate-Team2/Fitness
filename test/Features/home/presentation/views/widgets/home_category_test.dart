import 'package:fitness_app/Features/home/presentation/views/widgets/home_category.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
   Widget createWidgetUnderTest() {
    return const MaterialApp(
       localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
       home: Scaffold(
        body: CategorySection(),
      ),
    );
  }

  group('CategorySection Widget Tests', () {

     setUp(() {
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.implicitView!.physicalSize = const Size(1200, 800);
      binding.platformDispatcher.implicitView!.devicePixelRatio = 1.0;
    });

    testWidgets('should render category title and all 5 items', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

     expect(find.byType(Text), findsAtLeastNWidgets(6));

       expect(find.byType(InkWell), findsNWidgets(5));
      expect(find.byType(Image), findsNWidgets(5));
    });

    testWidgets('should display vertical dividers between items', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

       final dividers = find.byWidgetPredicate(
            (widget) => widget is Container &&
            widget.constraints?.maxWidth == 1,
      );

      expect(dividers, findsNWidgets(4));
    });

    testWidgets('items should have correct text style', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final categoryTexts = find.byType(Text);

      if (categoryTexts.evaluate().isNotEmpty) {
         final textWidget = tester.widget<Text>(categoryTexts.at(1));
        expect(textWidget.style?.color, AppColors.white);
        expect(textWidget.style?.fontSize, 14);
      }
    });
  });
}