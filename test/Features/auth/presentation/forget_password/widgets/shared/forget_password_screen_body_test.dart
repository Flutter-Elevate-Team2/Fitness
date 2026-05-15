import 'dart:async';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/shared/forget_password_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/forget_password_widgets/forget_password_page_view.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

 import '../reset_password_widgets/reset_password_screen_body_test.mocks.dart';

@GenerateMocks([ForgetPasswordViewModel])
void main() {
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> stateController;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    stateController = StreamController<ForgetPasswordState>.broadcast();

     when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
         body: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: const ForgetPasswordScreenBody(),
        ),
      ),
    );
  }

  group('ForgetPasswordScreenBody Flow Tests', () {
    testWidgets('should render and navigate through pages without provider errors', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(ForgetPasswordPageview), findsOneWidget);

       final ForgetPasswordPageview pageView = tester.widget(find.byType(ForgetPasswordPageview));

       pageView.onNextPage();
      await tester.pumpAndSettle();

     });

    testWidgets('should update email and pass it to pageview properties', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final ForgetPasswordPageview pageView = tester.widget(find.byType(ForgetPasswordPageview));
      const testEmail = 'dev@example.com';

       pageView.onEmailSubmitted?.call(testEmail);
      await tester.pump();

       final updatedPageView = tester.widget<ForgetPasswordPageview>(find.byType(ForgetPasswordPageview));
      expect(updatedPageView.userEmail, testEmail);
    });
  });
}