import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_icon_button.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_login_row.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'social_login_row_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LoginViewModel>()])
void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    when(mockLoginViewModel.state).thenReturn(const LoginState());
    when(mockLoginViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockLoginViewModel.close()).thenAnswer((_) => Future.value());
  });

  group('SocialLoginRow 100% Coverage Tests', () {
    Widget buildWidget({Function(String, String, String, String)? onGoogleSuccess}) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: BlocProvider<LoginViewModel>.value(
            value: mockLoginViewModel,
            child: SocialLoginRow(
              onGoogleSuccess: onGoogleSuccess ?? (e, f, l, p) {},
            ),
          ),
        ),
      );
    }

    testWidgets('should render all UI components correctly (Divider, Text, Buttons)', (tester) async {
      await tester.pumpWidget(buildWidget());

      // التحقق من الفواصل والنصوص
      expect(find.text('Or'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
      expect(find.byType(SocialIconButton), findsNWidgets(3));
    });

    testWidgets('should verify Google button asset path', (tester) async {
      await tester.pumpWidget(buildWidget());

      final googleBtn = tester.widget<SocialIconButton>(
        find.byType(SocialIconButton).at(1),
      );
      expect(googleBtn.assetPath.toLowerCase(), contains('google'));
    });

    testWidgets('should handle Facebook and Apple taps without error (TODO coverage)', (tester) async {
      await tester.pumpWidget(buildWidget());

      // تغطية الـ onTap الفارغة للفيسبوك وأبل
      await tester.tap(find.byType(SocialIconButton).first);
      await tester.tap(find.byType(SocialIconButton).last);
      await tester.pump();
    });

    // ملاحظة: لاختبار كود الـ try/catch داخل الـ onTap الخاص بجوجل 100%،
    // يفضل مستقبلاً نقل المنطق لـ Service، ولكن هنا سنختبر الأمان ضد الـ Crash
    testWidgets('should catch and log error when Google Sign-In fails', (tester) async {
      // هذا الاختبار سيضغط على الزر، وبما أننا في بيئة تيست ولم نحقن MockGoogleSignIn
      // فإنه سيذهب للـ catch block تلقائياً، مما يرفع التغطية للـ catch
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byType(SocialIconButton).at(1));
      await tester.pump();

      // التحقق من أن التطبيق لم ينهار
      expect(tester.takeException(), isNull);
    });

    testWidgets('verify layout padding and spacing', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // 1. الوصول للـ Padding المحيط بكلمة "Or" تحديداً
      final textFinder = find.text('Or');
      final paddingFinder = find.ancestor(
        of: textFinder,
        matching: find.byType(Padding),
      );

      final paddingWidget = tester.widget<Padding>(paddingFinder);

      // نستخدم الـ Matcher المرن للتأكد من القيم بغض النظر عن النوع (Directional or normal)
      expect(paddingWidget.padding, const EdgeInsets.symmetric(horizontal: 16));

      // 2. التحقق من المسافة العلوية (SizedBox height 16)
      // نبحث عن الـ SizedBox الموجود بين الـ Row الخاص بـ "Or" والـ Row الخاص بالأزرار
      final sizedBoxFinder = find.byType(SizedBox);

      // نتحقق من وجود SizedBox بارتفاع 16
      final allSizedBoxes = tester.widgetList<SizedBox>(sizedBoxFinder);
      final hasHeight16 = allSizedBoxes.any((s) => s.height == 16);

      expect(hasHeight16, isTrue, reason: 'Should have a vertical spacing of 16');
    });  });
}