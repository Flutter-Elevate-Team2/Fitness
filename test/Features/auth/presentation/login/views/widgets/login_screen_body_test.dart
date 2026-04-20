import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_screen_body.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockLoginViewModel extends MockCubit<LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(LoginButtonClickedEvent(email: '', password: ''));
  });

  setUp(() {
    mockViewModel = MockLoginViewModel();

    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockViewModel.state).thenReturn(const LoginState());
  });

  Widget createTestableWidget() {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: child!,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: BlocProvider<LoginViewModel>.value(
          value: mockViewModel,
          child: const LoginScreenBody(),
        ),
      ),
    );
  }

  group('LoginScreenBody Widget Tests', () {
    testWidgets(
      'login button should be disabled when email or password is empty',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        final loginButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(loginButton.onPressed, isNull);
      },
    );

    testWidgets(
      'login button should be enabled when both fields are not empty',
      (tester) async {
        await tester.pumpWidget(createTestableWidget());

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'test@test.com',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '123456');
        await tester.pumpAndSettle();

        final loginButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(loginButton.onPressed, isNotNull);
      },
    );

    testWidgets(
      'should call doIntent when form is valid and button is pressed',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;

        when(() => mockViewModel.doIntent(any())).thenReturn(null);

        await tester.pumpWidget(createTestableWidget());

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'test@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(1), 'Password123');

        await tester.pumpAndSettle();

        final loginButtonFinder = find.byType(ElevatedButton);

        await tester.ensureVisible(loginButtonFinder);
        await tester.tap(loginButtonFinder);

        await tester.pumpAndSettle();

        verify(
          () =>
              mockViewModel.doIntent(any(that: isA<LoginButtonClickedEvent>())),
        ).called(1);

        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets(
      'should change auto validateMode to always when form is invalid',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1200);

        await tester.pumpWidget(createTestableWidget());

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'invalid-email',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '123');

        await tester.pumpAndSettle();

        final loginButton = find.byType(ElevatedButton);
        await tester.ensureVisible(loginButton);
        await tester.tap(loginButton);

        await tester.pumpAndSettle();


        final form = tester.widget<Form>(find.byType(Form));
        expect(form.autovalidateMode, AutovalidateMode.always);

        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets('dispose should remove listeners and clean up controllers', (
      tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpWidget(const SizedBox());
    });
  });
}
