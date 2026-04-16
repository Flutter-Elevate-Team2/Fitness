import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/signup_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_view_model.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/pill_text_form_field.dart';
import 'package:mockito/annotations.dart';

import 'signup_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RegisterUseCase>()])
void main() {
  group('SignupScreen', () {
    late MockRegisterUseCase mockRegisterUseCase;

    setUp(() {
      mockRegisterUseCase = MockRegisterUseCase();

      // Register the mock SignUpViewModel in GetIt
      if (getIt.isRegistered<SignUpViewModel>()) {
        getIt.unregister<SignUpViewModel>();
      }
      getIt.registerFactory<SignUpViewModel>(
        () => SignUpViewModel(mockRegisterUseCase),
      );
    });

    tearDown(() {
      if (getIt.isRegistered<SignUpViewModel>()) {
        getIt.unregister<SignUpViewModel>();
      }
    });

    Widget buildWidget() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const SignupScreen(),
      );
    }

    testWidgets('renders the first step (account info) initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Step 1 shows greeting and form fields
      expect(find.text('Hey There'), findsOneWidget);
      expect(find.text('CREATE AN ACCOUNT'), findsOneWidget);
    });

    testWidgets('displays four text input fields on step 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PillTextFormField), findsNWidgets(4));
    });

    testWidgets('shows a PageView for step navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('PageView has NeverScrollableScrollPhysics (no manual swipe)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
    });
  });
}
