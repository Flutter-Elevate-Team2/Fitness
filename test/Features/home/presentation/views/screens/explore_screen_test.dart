import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/views/screens/explore_screen.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/explore_screen_body.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeViewModel extends MockCubit<HomeState> implements HomeViewModel {}

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
  late MockUserCubit mockUserCubit;

  setUp(() async {
    await getIt.reset();
    mockHomeViewModel = MockHomeViewModel();
    mockUserCubit = MockUserCubit();
    when(() => mockHomeViewModel.state).thenReturn(HomeState());
    when(() => mockHomeViewModel.initHome()).thenReturn(null);
    getIt.registerFactory<HomeViewModel>(() => mockHomeViewModel);
  });

  Widget createWidgetUnderTest({
    void Function({String? selectedGroupId})? callback,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<UserCubit>.value(
        value: mockUserCubit,
        child: ExploreScreen(onSeeAllWorkoutsTapped: callback),
      ),
    );
  }

  testWidgets(
    'ExploreScreen should provide HomeViewModel and render ExploreScreenBody',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(ExploreScreenBody), findsOneWidget);
      verify(() => mockHomeViewModel.initHome()).called(1);
    },
  );

  testWidgets('ExploreScreen should pass callback to ExploreScreenBody', (
    WidgetTester tester,
  ) async {
    bool callbackCalled = false;
    await tester.pumpWidget(
      createWidgetUnderTest(
        callback: ({selectedGroupId}) => callbackCalled = true,
      ),
    );

    final body = tester.widget<ExploreScreenBody>(
      find.byType(ExploreScreenBody),
    );
    body.onSeeAllWorkoutsTapped?.call();

    expect(callbackCalled, isTrue);
  });
}
