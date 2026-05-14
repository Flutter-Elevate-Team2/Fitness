import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_body.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

 class MockChangePasswordViewModel
    extends MockBloc<ChangePasswordEvents, ChangePasswordStates>
    implements ChangePasswordViewModel {}

void main() {
  late MockChangePasswordViewModel mockViewModel;

  setUpAll(() {
     registerFallbackValue(ChangePasswordEvent(request: ChangePasswordRequest(password: '', newPassword: '')));
  });

  setUp(() {
    mockViewModel = MockChangePasswordViewModel();

     when(() => mockViewModel.state).thenReturn(const ChangePasswordStates());

     whenListen(
      mockViewModel,
      Stream<ChangePasswordStates>.fromIterable([const ChangePasswordStates()]),
      initialState: const ChangePasswordStates(),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<ChangePasswordViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: ChangePasswordBody()),
      ),
    );
  }

  group('ChangePasswordBody Tests', () {
    setUp(() {
      mockViewModel = MockChangePasswordViewModel();

       when(() => mockViewModel.state).thenReturn(const ChangePasswordStates());

       whenListen(
        mockViewModel,
        const Stream<ChangePasswordStates>.empty(),
        initialState: const ChangePasswordStates(),
      );
    });

    testWidgets('Button should be disabled initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Button should be enabled when all fields are filled',
            (tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

           await tester.enterText(find.byType(TextFormField).at(0), '123456');
          await tester.enterText(find.byType(TextFormField).at(1), '654321');
          await tester.enterText(find.byType(TextFormField).at(2), '654321');

          await tester.pump();

          final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
          expect(button.onPressed, isNotNull);
        });

    testWidgets('Clicking button should call doIntent in ViewModel',
            (tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

           await tester.enterText(find.byType(TextFormField).at(0), 'oldPassword');
          await tester.enterText(find.byType(TextFormField).at(1), 'newPassword');
          await tester.enterText(find.byType(TextFormField).at(2), 'newPassword');

          await tester.pump();

           await tester.tap(find.textContaining('Done'));
          await tester.pump();

           verify(() => mockViewModel.doIntent(any())).called(1);
        });

    testWidgets('should show validation error if form is invalid', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '123456'); // Old
      await tester.enterText(find.byType(TextFormField).at(1), 'newPassword123'); // New
      await tester.enterText(find.byType(TextFormField).at(2), 'wrongConfirm'); // Confirm (Mismatch)

       await tester.pump();

       final doneButtonFinder = find.textContaining('Done');

       await tester.tap(doneButtonFinder);

       await tester.pump();

       final form = tester.widget<Form>(find.byType(Form));
      expect(form.autovalidateMode, AutovalidateMode.always);
    });
  });
}