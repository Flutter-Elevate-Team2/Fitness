import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_action_buttons.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_bottom_section.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_indicator.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_page_view.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'onboarding_action_buttons_test.mocks.dart';

void main() {
  late MockOnboardingViewModel mockViewModel;
  late PageController pageController;

  final List<OnboardingEntity> dummyPages = [
    OnboardingEntity(title: 'T1', description: 'D1', image: 'I1'),
    OnboardingEntity(title: 'T2', description: 'D2', image: 'I2'),
  ];

  setUp(() {
    mockViewModel = MockOnboardingViewModel();
    pageController = PageController();

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
      home: Scaffold(
        body: BlocProvider<OnboardingViewModel>.value(
          value: mockViewModel,
          child: OnboardingBottomSection(
            pageController: pageController,
            pages: dummyPages,
            state: state,
          ),
        ),
      ),
    );
  }

  testWidgets('should render all child widgets correctly', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);

    // Arrange
    const state = OnboardingState(currentIndex: 0);

    // Act
    await tester.pumpWidget(createWidgetUnderTest(state));

    // Assert
    expect(find.byType(OnboardingPageView), findsOneWidget);
    expect(find.byType(OnboardingIndicator), findsOneWidget);
    expect(find.byType(OnboardingActionButtons), findsOneWidget);

    final buttonsWidget = tester.widget<OnboardingActionButtons>(
      find.byType(OnboardingActionButtons),
    );
    expect(buttonsWidget.currentIndex, 0);
    expect(buttonsWidget.isLastPage, false);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should update isLastPage when on the last page', (tester) async {
    const state = OnboardingState(currentIndex: 1);

    // Act
    await tester.pumpWidget(createWidgetUnderTest(state));

    // Assert
    final buttonsWidget = tester.widget<OnboardingActionButtons>(
      find.byType(OnboardingActionButtons),
    );
    expect(buttonsWidget.isLastPage, true);
  });
}
