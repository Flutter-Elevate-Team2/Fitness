import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/edit_profile/edit_profile_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_profile_form.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/user_info_section.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionController extends Mock implements SessionController {
  UserEntity? _user;

  @override
  UserEntity? get user => _user;

  void setUser(UserEntity? user) {
    _user = user;
  }

  @override
  void updateUser(UserEntity user) {
    _user = user;
  }
}

class MockEditProfileViewModel
    extends MockBloc<EditProfileEvent, EditProfileStates>
    implements EditProfileViewModel {}

class FakeEditProfileEvent extends Fake implements EditProfileEvent {}

class FakeEditProfileStates extends Fake implements EditProfileStates {}

void main() {
  late MockSessionController mockSessionController;
  late MockEditProfileViewModel mockEditProfileViewModel;
  late UserEntity testUser;

  setUpAll(() {
    registerFallbackValue(FakeEditProfileEvent());
    registerFallbackValue(FakeEditProfileStates());
  });

  setUp(() async {
    mockSessionController = MockSessionController();
    mockEditProfileViewModel = MockEditProfileViewModel();

    testUser = UserEntity(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      weight: 70,
      goal: 'lose_weight',
      activityLevel: 'level1',
      photo: '',
      gender: '',
      age: 0,
      height: 0,
    );

    mockSessionController.setUser(testUser);

    if (getIt.isRegistered<SessionController>()) {
      await getIt.reset();
    }

    getIt.registerSingleton<SessionController>(mockSessionController);

    when(
      () => mockEditProfileViewModel.state,
    ).thenReturn(const EditProfileStates(editProfileState: null));
  });

  tearDown(() async {
    if (getIt.isRegistered<SessionController>()) {
      await getIt.reset();
    }
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
      home: BlocProvider<EditProfileViewModel>.value(
        value: mockEditProfileViewModel,
        child: EditProfileScreen(user: testUser),
      ),
    );
  }

  group('EditProfileScreen Widget Tests', () {
    testWidgets('Renders EditProfileScreen and EditProfileForm correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileForm), findsOneWidget);
      expect(find.byType(UserInfoSection), findsOneWidget);
    });

    testWidgets('Triggers update successfully in EditProfileScreen', (
      WidgetTester tester,
    ) async {
      when(
        () => mockEditProfileViewModel.doIntent(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final firstNameField = find.byType(TextFormField).first;
      await tester.enterText(firstNameField, 'UpdatedName');
      await tester.pump();

      final buttonFinder = find.byType(ElevatedButton);
      await tester.dragUntilVisible(
        buttonFinder,
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pump();

      await tester.tap(buttonFinder);
      await tester.pump();

      verify(() => mockEditProfileViewModel.doIntent(any())).called(1);
    });
  });
}
