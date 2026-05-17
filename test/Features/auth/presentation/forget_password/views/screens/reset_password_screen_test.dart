import 'package:fitness_app/Features/auth/presentation/forget_password/views/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_screen_body.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

import '../../widgets/forget_password_widgets/forget_password_email_screen_test.mocks.dart';


@GenerateMocks([ForgetPasswordViewModel])
void main() {
  final getIt = GetIt.instance;
  late MockForgetPasswordViewModel mockViewModel;

  setUp(() async {
    await getIt.reset();
    mockViewModel = MockForgetPasswordViewModel();

     when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(mockViewModel.close()).thenAnswer((_) async => {});

     getIt.registerFactory<ForgetPasswordViewModel>(() => mockViewModel);
  });

  Widget createWidgetUnderTest({String? email}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<ForgetPasswordViewModel>.value(
        value: mockViewModel,
        child: Scaffold(
          body: ResetPasswordScreen(
            onPreviousPage: () {},
            userEmail: email,
          ),
        ),
      ),
    );
  }

  group('ResetPasswordScreen Widget Tests', () {
    testWidgets('should render ResetPasswordScreenBody successfully', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(email: 'test@example.com'));

       expect(find.byType(ResetPasswordScreenBody), findsOneWidget);
    });

    testWidgets('should pass userEmail correctly to ResetPasswordScreenBody', (tester) async {
      const testEmail = 'dev@fitness.com';
      await tester.pumpWidget(createWidgetUnderTest(email: testEmail));

       final bodyWidget = tester.widget<ResetPasswordScreenBody>(
        find.byType(ResetPasswordScreenBody),
      );

      expect(bodyWidget.userEmail, equals(testEmail));
    });
  });
}