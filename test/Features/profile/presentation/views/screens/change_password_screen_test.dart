import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/change_password_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_body.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_shimmer.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordViewModel
    extends MockBloc<ChangePasswordEvents, ChangePasswordStates>
    implements ChangePasswordViewModel {}
class MockChangePasswordEntity extends Mock implements ChangePasswordEntity {}
void main() {
  late MockChangePasswordViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockChangePasswordViewModel();
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
        child: const ChangePasswordScreen(),
      ),
    );
  }

  group('ChangePasswordScreen Tests', () {
    testWidgets('renders ChangePasswordShimmer when isLoading is true', (tester) async {
       when(() => mockViewModel.state).thenReturn(
        const ChangePasswordStates(changePasswordState: BaseState(isLoading: true)),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ChangePasswordShimmer), findsOneWidget);
      expect(find.byType(ChangePasswordBody), findsNothing);
    });

    testWidgets('renders ChangePasswordBody when isLoading is false', (tester) async {
      when(() => mockViewModel.state).thenReturn(
        const ChangePasswordStates(changePasswordState: BaseState(isLoading: false)),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ChangePasswordBody), findsOneWidget);
      expect(find.byType(ChangePasswordShimmer), findsNothing);
    });

    testWidgets('shows Success SnackBar and pops when data is returned', (tester) async {
      final mockEntity = MockChangePasswordEntity();
       when(() => mockViewModel.state).thenReturn(const ChangePasswordStates());

       whenListen(
        mockViewModel,
        Stream.fromIterable([
            ChangePasswordStates(changePasswordState: BaseState(data: mockEntity)),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      final context = tester.element(find.byType(ChangePasswordScreen));
      final successMessage = context.l10n.passwordChangedSuccess;

      expect(find.text(successMessage), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      });

    testWidgets('shows Error SnackBar when errorMessage is present', (tester) async {
      when(() => mockViewModel.state).thenReturn(const ChangePasswordStates());

      whenListen(
        mockViewModel,
        Stream.fromIterable([
          const ChangePasswordStates(changePasswordState: BaseState(errorMessage: "Error Occurred")),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error Occurred'), findsOneWidget);
    });
  });
}