import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_screen_body.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_skip_button.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_bottom_section.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'onboarding_action_buttons_test.mocks.dart';

void main() {
  late MockOnboardingViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockOnboardingViewModel();
    when(mockViewModel.state).thenReturn(const OnboardingState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest(OnboardingState state) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<OnboardingViewModel>.value(
        value: mockViewModel,
        child: OnboardingScreenBody(state: state),
      ),
    );
  }

  group('OnboardingScreenBody Tests', () {
    Future<void> setTestScreenSize(WidgetTester tester) async {
      tester.view.physicalSize = const Size(
        1080,
        2400,
      );
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
    }

    testWidgets('should show Skip button on first and second pages', (
      tester,
    ) async {
      await setTestScreenSize(tester);

      // Page 0
      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 0)),
      );
      expect(find.byType(OnboardingSkipButton), findsOneWidget);

      // Page 1
      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 1)),
      );
      expect(find.byType(OnboardingSkipButton), findsOneWidget);
    });

    testWidgets('should HIDE Skip button on the last page', (tester) async {
      await setTestScreenSize(tester);

      // Page 2 (Last page)
      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 2)),
      );
      expect(find.byType(OnboardingSkipButton), findsNothing);
    });

    testWidgets('should render OnboardingBottomSection', (tester) async {
      await setTestScreenSize(tester);

      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 0)),
      );
      expect(find.byType(OnboardingBottomSection), findsOneWidget);
    });

    testWidgets('should cover different image positions (switch logic)', (
      tester,
    ) async {
      await setTestScreenSize(tester);

      // Case Index 0
      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 0)),
      );
      // Case Index 1
      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 1)),
      );
      // Case Index 2
      await tester.pumpWidget(
        createWidgetUnderTest(const OnboardingState(currentIndex: 2)),
      );

      expect(find.byType(OnboardingScreenBody), findsOneWidget);
    });
  });
}
