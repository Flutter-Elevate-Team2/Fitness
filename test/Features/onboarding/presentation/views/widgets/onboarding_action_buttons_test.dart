import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_action_buttons.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'onboarding_action_buttons_test.mocks.dart';

@GenerateMocks([OnboardingViewModel, PageController])
void main() {
  late MockOnboardingViewModel mockViewModel;
  late MockPageController mockPageController;

  setUp(() {
    mockViewModel = MockOnboardingViewModel();
    mockPageController = MockPageController();

    when(mockViewModel.state).thenReturn(const OnboardingState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest({
    required int currentIndex,
    required bool isLastPage,
  }) {
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
          child: OnboardingActionButtons(
            pageController: mockPageController,
            currentIndex: currentIndex,
            isLastPage: isLastPage,
          ),
        ),
      ),
    );
  }

  group('OnboardingActionButtons Tests', () {
    testWidgets('should call nextPage on controller when Next is clicked', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 0, isLastPage: false),
      );

      final BuildContext context = tester.element(
        find.byType(OnboardingActionButtons),
      );

      await tester.tap(find.text(context.l10n.next));
      await tester.pump();

      verify(
        mockPageController.nextPage(
          duration: anyNamed('duration'),
          curve: anyNamed('curve'),
        ),
      ).called(1);
    });

    testWidgets('should call previousPage on controller when Back is clicked', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 1, isLastPage: false),
      );

      final BuildContext context = tester.element(
        find.byType(OnboardingActionButtons),
      );

      await tester.tap(find.text(context.l10n.back));
      await tester.pump();

      verify(
        mockPageController.previousPage(
          duration: anyNamed('duration'),
          curve: anyNamed('curve'),
        ),
      ).called(1);
    });

    testWidgets('should call doIntent on last page', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 2, isLastPage: true),
      );

      final BuildContext context = tester.element(
        find.byType(OnboardingActionButtons),
      );

      await tester.tap(find.text(context.l10n.doIt));
      await tester.pump();

      verify(mockViewModel.doIntent(any)).called(1);
    });

    testWidgets('should render SizedBox space when currentIndex > 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(currentIndex: 1, isLastPage: false),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
