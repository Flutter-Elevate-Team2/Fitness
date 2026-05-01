import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/update_button_section.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEditProfileViewModel extends MockBloc<dynamic, EditProfileStates>
    implements EditProfileViewModel {}

class FakeEditProfileStates extends Fake implements EditProfileStates {}

void main() {
  late MockEditProfileViewModel mockViewModel;
  late GlobalKey<FormState> testFormKey;
  bool isPressedCalled = false;

  setUpAll(() {
    registerFallbackValue(FakeEditProfileStates());
  });

  setUp(() {
    mockViewModel = MockEditProfileViewModel();
    testFormKey = GlobalKey<FormState>();
    isPressedCalled = false;

    when(() => mockViewModel.state).thenReturn(const EditProfileStates());
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest({
    bool isButtonEnabled = true,
    EditProfileStates? state,
  }) {
    if (state != null) {
      when(() => mockViewModel.state).thenReturn(state);
    }

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: Form(
          key: testFormKey,
          child: BlocProvider<EditProfileViewModel>.value(
            value: mockViewModel,
            child: UpdateButtonSection(
              isButtonEnabled: isButtonEnabled,
              formKey: testFormKey,
              onPressed: () {
                isPressedCalled = true;
              },
            ),
          ),
        ),
      ),
    );
  }

  group('UpdateButtonSection Widget Tests', () {
    testWidgets(
      'renders correctly and triggers onPressed when enabled and validated',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest(isButtonEnabled: true));
        await tester.pumpAndSettle();

        expect(find.byType(CustomButton), findsOneWidget);

        await tester.tap(find.byType(CustomButton));
        await tester.pumpAndSettle();

        expect(isPressedCalled, isTrue);
      },
    );

    testWidgets('does not trigger onPressed when button is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isButtonEnabled: false));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(isPressedCalled, isFalse);
    });
  });
}
