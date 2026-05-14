import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_screen_body.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

 @GenerateNiceMocks([MockSpec<LoginViewModel>()])
import 'login_screen_body_test.mocks.dart';

void main() {
  late MockLoginViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockLoginViewModel();

    // إعداد الـ Stubbing
    when(mockViewModel.state).thenReturn(const LoginState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createTestableWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        // تغليف بـ SingleChildScrollView إذا كان التصميم يحتاج مساحة
        body: BlocProvider<LoginViewModel>.value(
          value: mockViewModel,
          child: const LoginScreenBody(),
        ),
      ),
    );
  }

  group('LoginScreenBody Widget Tests', () {
    testWidgets(
      'should call doIntent when form is valid and button is pressed',
          (tester) async {
        // 1. تكبير الشاشة لتجنب "Off-screen" error
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestableWidget());

        // 2. إدخال البيانات
        await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
        await tester.enterText(find.byType(TextFormField).at(1), 'Password123');

        // مهم جداً لتفعيل الزر بعد الكتابة
        await tester.pumpAndSettle();

        // 3. التأكد من ظهور الزر والضغط عليه
        final loginButtonFinder = find.byType(ElevatedButton);
        await tester.ensureVisible(loginButtonFinder);
        await tester.tap(loginButtonFinder);

        await tester.pump();

        // 4. التحقق (Verify) باستخدام Matcher
        verify(
          mockViewModel.doIntent(argThat(isA<LoginButtonClickedEvent>())),
        ).called(1);

        // إعادة حجم الشاشة للوضع الافتراضي بعد التيست
        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets(
      'login button should be disabled when fields are empty',
          (tester) async {
        await tester.pumpWidget(createTestableWidget());
        await tester.pump();

        final loginButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(loginButton.onPressed, isNull);
      },
    );
  });
}