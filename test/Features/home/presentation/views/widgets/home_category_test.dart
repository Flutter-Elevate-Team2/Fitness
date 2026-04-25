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
      final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
      // ضبط حجم الشاشة للتأكد من أن جميع العناصر تظهر بوضوح ولا يحدث Overflow
      binding.platformDispatcher.implicitView!.physicalSize = const Size(1200, 800);
      binding.platformDispatcher.implicitView!.devicePixelRatio = 1.0;
    });

    testWidgets('1. Should render category title and all 5 items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // التحقق من وجود عنوان القسم "Category" + الـ 5 تصنيفات = 6 نصوص
      expect(find.byType(Text), findsAtLeastNWidgets(6));
      expect(find.byType(InkWell), findsNWidgets(5));
      expect(find.byType(Image), findsNWidgets(5));
    });

    testWidgets('2. Should display exactly 4 vertical dividers between 5 items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // البحث عن الـ Container الذي يمثل الفاصل (width: 1, height: 50)
      final dividers = find.byWidgetPredicate(
            (widget) =>
        widget is Container &&
            widget.constraints?.maxWidth == 1 &&
            widget.constraints?.minHeight == 50,
      );

      expect(dividers, findsNWidgets(4));
    });

    testWidgets('3. Items should have correct style (Color & FontSize)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // نبحث عن نص أحد العناصر، مثلاً "Gym"
      // (لاحظ أن index 0 هو عنوان القسم "Category"، لذا نبدأ من 1)
      final categoryTexts = find.byType(Text);
      final textWidget = tester.widget<Text>(categoryTexts.at(1));

      expect(textWidget.style?.color, AppColors.white);
      // تصحيح: الـ FontSize في الكود هو 11 وليس 14
      expect(textWidget.style?.fontSize, 11);
    });

    testWidgets('4. Category items should be clickable', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // التأكد من أن الـ InkWell قابل للتفاعل
      final firstCategory = find.byType(InkWell).first;
      await tester.tap(firstCategory);
      await tester.pump();

      // هنا يمكنك مستقبلاً إضافة نداء لـ MockRouter للتأكد من الملاحة
    });
  });
}