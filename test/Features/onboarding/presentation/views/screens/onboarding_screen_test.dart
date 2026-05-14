import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/screens/onboarding_screen.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'onboarding_screen_test.mocks.dart';

@GenerateMocks([OnboardingViewModel])
void main() {
  late MockOnboardingViewModel mockViewModel;
  late StreamController<OnboardingState> stateController;

  setUp(() {
    mockViewModel = MockOnboardingViewModel();
    stateController = StreamController<OnboardingState>.broadcast();

    if (getIt.isRegistered<OnboardingViewModel>()) {
      getIt.unregister<OnboardingViewModel>();
    }
    getIt.registerFactory<OnboardingViewModel>(() => mockViewModel);

    when(mockViewModel.state).thenReturn(const OnboardingState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    return MaterialApp.router(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }

  group('OnboardingScreen Coverage Tests', () {
    Future<void> setScreenSize(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1500, 2500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
    }

    testWidgets('should render OnboardingScreen and show Body', (tester) async {
      await setScreenSize(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets(
      'should navigate to login when isFinished is true (Listener Test)',
      (tester) async {
        await setScreenSize(tester);

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const OnboardingScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const SizedBox(),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            localizationsDelegates: const [AppLocalizations.delegate],
            routerConfig: router,
          ),
        );

        stateController.add(const OnboardingState(isFinished: true));

        await tester.pumpAndSettle();

        expect(router.state.matchedLocation, contains('login'));
      },
    );
  });
}
