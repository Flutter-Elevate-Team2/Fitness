import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/logout_dialog.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockProfileViewModel extends MockBloc<ProfileEvents, ProfileStates>
    implements ProfileViewModel {}

void main() {
  late MockProfileViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(LogoutEvent());
  });

  setUp(() {
    mockViewModel = MockProfileViewModel();
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
      home: Scaffold(
        body: BlocProvider<ProfileViewModel>.value(
          value: mockViewModel,
          child: const LogoutDialog(),
        ),
      ),
    );
  }

  testWidgets('closes dialog when cancel button is pressed',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

         final cancelButton = find.byType(CustomButton).at(0);

        expect(cancelButton, findsOneWidget);

        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        expect(find.byType(LogoutDialog), findsNothing);
      });

  testWidgets('triggers LogoutEvent and closes dialog when logout button is pressed',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

         final logoutButton = find.byType(CustomButton).at(1);

        expect(logoutButton, findsOneWidget);

        await tester.tap(logoutButton);
        await tester.pumpAndSettle();

        verify(() => mockViewModel.doIntent(any(that: isA<LogoutEvent>()))).called(1);
        expect(find.byType(LogoutDialog), findsNothing);
      });
}