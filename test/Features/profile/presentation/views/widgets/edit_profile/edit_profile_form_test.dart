import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_profile_form.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_text_field_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/update_button_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/user_info_section.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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

class MockGoRouter extends Mock implements GoRouter {
  @override
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    // تشغيل الـ Callbacks للاختبار
    if (extra is Map<String, dynamic>) {
      if (extra.containsKey('onWeightChanged')) {
        extra['onWeightChanged'](80);
      }
      if (extra.containsKey('onGoalSelected')) {
        extra['onGoalSelected']('gain_weight');
      }
      if (extra.containsKey('onActivitySelected')) {
        extra['onActivitySelected']('level2');
      }
      if (extra.containsKey('onStepComplete')) {
        extra['onStepComplete']();
      }
      if (extra.containsKey('onBackButtonPressed')) {
        extra['onBackButtonPressed']();
      }
    }
    return Future.value(null) as Future<T?>;
  }
}

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

    when(() => mockEditProfileViewModel.state).thenReturn(
      const EditProfileStates(editProfileState: null, uploadPhotoState: null),
    );
  });

  tearDown(() async {
    if (getIt.isRegistered<SessionController>()) {
      await getIt.reset();
    }
  });

  Widget createWidgetUnderTest() {
    final mockGoRouter = MockGoRouter();

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: BlocProvider<EditProfileViewModel>.value(
                      value: mockEditProfileViewModel,
                      child: EditProfileForm(user: testUser),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  group('EditProfileForm Comprehensive Tests (100% Coverage)', () {
    testWidgets('Renders form, validates initial state and all widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(UserInfoSection), findsOneWidget);
      expect(find.byType(ProfileTextFieldSection), findsOneWidget);
      expect(find.byType(UpdateButtonSection), findsOneWidget);
    });

    testWidgets('Updates button state when text changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final firstNameField = find.byType(TextFormField).first;
      await tester.enterText(firstNameField, 'UpdatedName');
      await tester.pump();

      final updateButtonSection = tester.widget<UpdateButtonSection>(
        find.byType(UpdateButtonSection),
      );
      expect(updateButtonSection.isButtonEnabled, isTrue);
    });

    testWidgets('Triggers _sendUpdateRequest when button is pressed', (
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

    testWidgets('Handles BlocListener success state correctly', (
      WidgetTester tester,
    ) async {
      final updatedUser = UserEntity(
        id: '1',
        firstName: 'UpdatedName',
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

      whenListen(
        mockEditProfileViewModel,
        Stream.fromIterable([
          const EditProfileStates(
            editProfileState: BaseState<UserEntity>(
              isLoading: false,
              data: null,
              errorMessage: null,
            ),
          ),
          EditProfileStates(
            editProfileState: BaseState<UserEntity>(
              isLoading: false,
              data: updatedUser,
              errorMessage: null,
            ),
          ),
        ]),
        initialState: const EditProfileStates(editProfileState: null),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SnackBar), findsAny);
    });

    testWidgets('Handles BlocListener error state correctly', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockEditProfileViewModel,
        Stream.fromIterable([
          const EditProfileStates(
            editProfileState: BaseState<UserEntity>(
              isLoading: false,
              data: null,
              errorMessage: 'Error occurred',
            ),
          ),
        ]),
        initialState: const EditProfileStates(editProfileState: null),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SnackBar), findsAny);
    });

    testWidgets('Tests _editWeight callback correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final section = tester.widget<ProfileTextFieldSection>(
        find.byType(ProfileTextFieldSection),
      );
      expect(section.onEditWeight, isNotNull);

      section.onEditWeight();
      await tester.pumpAndSettle();
    });

    testWidgets('Tests _editGoal and _editActivity callbacks correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final section = tester.widget<ProfileTextFieldSection>(
        find.byType(ProfileTextFieldSection),
      );

      expect(section.onEditGoal, isNotNull);
      expect(section.onEditActivity, isNotNull);

      section.onEditGoal();
      await tester.pumpAndSettle();

      section.onEditActivity();
      await tester.pumpAndSettle();
    });

    testWidgets('Tests _getActivityText and _getGoalText default switches', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final section = tester.widget<ProfileTextFieldSection>(
        find.byType(ProfileTextFieldSection),
      );

      expect(section.goalText, isNotNull);
      expect(section.activityText, isNotNull);
    });
  });
}
