import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_chat_screen.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_screen.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_welcome_screen.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mock Cubit ---
class MockSmartCoachViewModel extends MockCubit<SmartCoachState> implements SmartCoachViewModel {}

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
  late MockSmartCoachViewModel mockViewModel;
  late MockUserCubit mockUserCubit;

  setUp(() {
    mockViewModel = MockSmartCoachViewModel();
    mockUserCubit = MockUserCubit();

    // Stub setup methods called during SmartCoachScreen construction
    when(() => mockViewModel.setLocalizedStrings(
          defaultSessionTitle: any(named: 'defaultSessionTitle'),
          safetyBlockMessage: any(named: 'safetyBlockMessage'),
        )).thenReturn(null);
    when(() => mockViewModel.loadHistory()).thenReturn(null);

    // Stub concrete getters that the UI reads directly from the ViewModel.
    when(() => mockViewModel.historySessions).thenReturn(const []);
    when(() => mockViewModel.isStreaming).thenReturn(false);
    when(() => mockViewModel.currentSessionId).thenReturn(null);

    // Provide the mock ViewModel to the DI container
    getIt.allowReassignment = true;
    if (getIt.isRegistered<SmartCoachViewModel>()) {
      getIt.unregister<SmartCoachViewModel>();
    }
    getIt.registerFactory<SmartCoachViewModel>(() => mockViewModel);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<UserCubit>.value(
        value: mockUserCubit,
        child: const SmartCoachScreen(),
      ),
    );
  }

  group('SmartCoachScreen Routing Tests', () {
    testWidgets('renders CircularProgressIndicator when state is SmartCoachInitial/SmartCoachLoading', (tester) async {
      whenListen(
        mockViewModel,
        Stream.fromIterable([const SmartCoachInitial()]),
        initialState: const SmartCoachInitial(),
      );

      await tester.pumpWidget(buildTestWidget());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders SmartCoachWelcomeScreen when state is SmartCoachSessionLoaded', (tester) async {
      whenListen(
        mockViewModel,
        Stream.fromIterable([const SmartCoachSessionLoaded(sessions: [])]),
        initialState: const SmartCoachSessionLoaded(sessions: []),
      );

      await tester.pumpWidget(buildTestWidget());
      
      expect(find.byType(SmartCoachWelcomeScreen), findsOneWidget);
    });

    testWidgets('renders SmartCoachChatScreen when state is SmartCoachStreamDone (or Streaming/Error)', (tester) async {
      whenListen(
        mockViewModel,
        Stream.fromIterable([const SmartCoachStreamDone(messages: [])]),
        initialState: const SmartCoachStreamDone(messages: []),
      );

      await tester.pumpWidget(buildTestWidget());
      
      expect(find.byType(SmartCoachChatScreen), findsOneWidget);
    });
  });
}
