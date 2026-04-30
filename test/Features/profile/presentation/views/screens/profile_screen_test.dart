import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/profile_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_screen_body.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_shimmer.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileViewModel extends MockBloc<ProfileEvents, ProfileStates>
    implements ProfileViewModel {}

void main() {
  late MockProfileViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(GetUserProfileEvent());
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
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: BlocProvider<ProfileViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: ProfileScreen()),
      ),
    );
  }

  testWidgets('renders ProfilePageShimmer when profileState is loading', (
      WidgetTester tester,
      ) async {
     when(
          () => mockViewModel.state,
    ).thenReturn(const ProfileStates(profileState: BaseState(isLoading: true)));

    await tester.pumpWidget(createWidgetUnderTest());

     expect(find.byType(ProfilePageShimmer), findsOneWidget);

     expect(find.byType(ProfileScreenBody), findsNothing);
  });

  testWidgets('renders ErrorStateWidget and matches error text', (
    WidgetTester tester,
  ) async {
    const errorMsg = 'Connection Error';
    when(() => mockViewModel.state).thenReturn(
      const ProfileStates(
        profileState: BaseState(isLoading: false, errorMessage: errorMsg),
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text(errorMsg), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('triggers GetUserProfileEvent on retry button click', (
    WidgetTester tester,
  ) async {
    when(() => mockViewModel.state).thenReturn(
      const ProfileStates(
        profileState: BaseState(isLoading: false, errorMessage: 'Error'),
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byType(ElevatedButton));

    verify(
      () => mockViewModel.doIntent(any(that: isA<GetUserProfileEvent>())),
    ).called(1);
  });

  testWidgets('renders ProfileScreenBody when data is loaded successfully', (
    WidgetTester tester,
  ) async {
    final user = UserEntity(
      id: '1',
      email: 'test@test.com',
      firstName: '',
      lastName: '',
      photo: '',
      gender: '',
      age: 20,
      weight: 70,
      height: 70,
      activityLevel: '',
      goal: '',
    );

    when(() => mockViewModel.state).thenReturn(
      ProfileStates(profileState: BaseState(isLoading: false, data: user)),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(ProfileScreenBody), findsOneWidget);
  });

  testWidgets('shows loading dialog during logout process', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockViewModel,
      Stream.fromIterable([
        const ProfileStates(logoutState: BaseState(isLoading: true)),
      ]),
      initialState: const ProfileStates(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows SnackBar on logout error', (WidgetTester tester) async {
    const logoutError = 'Logout Failed';

    whenListen(
      mockViewModel,
      Stream.fromIterable([
        const ProfileStates(
          logoutState: BaseState(isLoading: false, errorMessage: logoutError),
        ),
      ]),
      initialState: const ProfileStates(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text(logoutError), findsOneWidget);
  });
}
