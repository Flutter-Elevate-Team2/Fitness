import 'dart:async';
import 'package:fitness_app/Features/auth/presentation/forget_password/views/screens/forget_password_screen.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';

import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/widgets/shared/forget_password_screen_body.dart';

import '../../widgets/reset_password_widgets/reset_password_screen_body_test.mocks.dart';

@GenerateMocks([ForgetPasswordViewModel])
void main() {
  final getIt = GetIt.instance;
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> stateController;

  setUp(() async {
     await getIt.reset();

    mockViewModel = MockForgetPasswordViewModel();
    stateController = StreamController<ForgetPasswordState>.broadcast();

     when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);

     when(mockViewModel.close()).thenAnswer((_) async => {});

     getIt.registerFactory<ForgetPasswordViewModel>(() => mockViewModel);
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
       localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
       home: ForgetPasswordScreen(),
    );
  }
  group('ForgetPasswordScreen Widget Tests', () {
    testWidgets('should render ForgetPasswordScreen and provide ViewModel', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(ForgetPasswordScreenBody), findsOneWidget);
    });

    testWidgets(
      'should successfully provide MockViewModel from getIt to ForgetPasswordScreenBody',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

         final finder = find.byType(ForgetPasswordScreenBody);
        expect(finder, findsOneWidget);

         final BuildContext context = tester.element(finder);

      final providedViewModel = BlocProvider.of<ForgetPasswordViewModel>(
          context,
        );

        expect(providedViewModel, equals(mockViewModel));
      },
    );
  });
}
