import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/views/screens/home_screen.dart';
import 'package:fitness_app/Features/home/presentation/views/screens/explore_screen.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/workouts_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/workouts_screen.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockHomeViewModel extends MockCubit<HomeState> implements HomeViewModel {}

class MockWorkoutsViewModel extends MockCubit<WorkoutsStates>
    implements WorkoutsViewModel {}

class MockSmartCoachViewModel extends MockCubit<SmartCoachState>
    implements SmartCoachViewModel {}

class MockProfileViewModel extends MockCubit<ProfileStates>
    implements ProfileViewModel {}

class MockUserCubit extends Mock implements UserCubit {
  @override
  UserEntity? get state => null;

  @override
  Stream<UserEntity?> get stream => const Stream.empty();

  @override
  bool get isClosed => false;

  @override
  Future<void> close() async {}
}

void main() {
  late MockHomeViewModel mockHomeViewModel;
  late MockWorkoutsViewModel mockWorkoutsViewModel;
  late MockSmartCoachViewModel mockSmartCoachViewModel;
  late MockProfileViewModel mockProfileViewModel;
  late MockUserCubit mockUserCubit;

  setUp(() async {
    await getIt.reset();
    mockHomeViewModel = MockHomeViewModel();
    mockWorkoutsViewModel = MockWorkoutsViewModel();
    mockSmartCoachViewModel = MockSmartCoachViewModel();
    mockProfileViewModel = MockProfileViewModel();
    mockUserCubit = MockUserCubit();

    when(() => mockHomeViewModel.state).thenReturn(HomeState());
    when(() => mockHomeViewModel.initHome()).thenAnswer((_) async {});

    when(() => mockWorkoutsViewModel.state).thenReturn(WorkoutsStates());

    // SmartCoachScreen reads these from ViewModel during build
    when(() => mockSmartCoachViewModel.setLocalizedStrings(
          defaultSessionTitle: any(named: 'defaultSessionTitle'),
          safetyBlockMessage: any(named: 'safetyBlockMessage'),
        )).thenReturn(null);
    when(() => mockSmartCoachViewModel.loadHistory()).thenReturn(null);
    when(() => mockSmartCoachViewModel.historySessions).thenReturn(const []);
    when(() => mockSmartCoachViewModel.isStreaming).thenReturn(false);
    when(() => mockSmartCoachViewModel.currentSessionId).thenReturn(null);

    when(() => mockProfileViewModel.state).thenReturn(const ProfileStates());

    getIt.registerFactory<HomeViewModel>(() => mockHomeViewModel);
    getIt.registerFactory<WorkoutsViewModel>(() => mockWorkoutsViewModel);
    getIt.registerFactory<SmartCoachViewModel>(() => mockSmartCoachViewModel);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>.value(value: mockUserCubit),
          BlocProvider<ProfileViewModel>.value(value: mockProfileViewModel),
        ],
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('should start with ExploreScreen (index 0)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();

    expect(find.byType(ExploreScreen), findsOneWidget);
  });

  testWidgets('should switch tabs when CustomBottomNavBar is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    final navBarFinder = find.byType(CustomBottomNavBar);
    expect(navBarFinder, findsOneWidget);

    final CustomBottomNavBar navBar = tester.widget(navBarFinder);
    navBar.onTap(2);

    await tester.pumpAndSettle();

    expect(find.byType(WorkoutsScreen), findsOneWidget);
  });

  testWidgets(
    'should switch to WorkoutsTab when onSeeAllWorkoutsTapped is called',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final exploreScreenFinder = find.byType(ExploreScreen);
      expect(exploreScreenFinder, findsOneWidget);

      final ExploreScreen exploreScreen = tester.widget(exploreScreenFinder);

      exploreScreen.onSeeAllWorkoutsTapped?.call(selectedGroupId: 'test_id');

      await tester.pumpAndSettle();

      expect(find.byType(WorkoutsScreen), findsOneWidget);
      final workoutsScreen = tester.widget<WorkoutsScreen>(
        find.byType(WorkoutsScreen),
      );
      expect(workoutsScreen.initialGroupId, 'test_id');
    },
  );
}
