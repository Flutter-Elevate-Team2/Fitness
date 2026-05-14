import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_skip_button.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
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

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Stack(
          children: [
            BlocProvider<OnboardingViewModel>.value(
              value: mockViewModel,
              child: const OnboardingSkipButton(),
            ),
          ],
        ),
      ),
    );
  }

  group('OnboardingSkipButton Tests', () {
    testWidgets('should render skip button with correct text', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final BuildContext context = tester.element(
        find.byType(OnboardingSkipButton),
      );

      expect(find.text(context.l10n.skip), findsOneWidget);
    });

    testWidgets(
      'should call doIntent with OnboardingGetStartedClickedEvent when clicked',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.byType(TextButton));
        await tester.pump();

        verify(
          mockViewModel.doIntent(
            argThat(isA<OnboardingGetStartedClickedEvent>()),
          ),
        ).called(1);
      },
    );

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textWidget = tester.widget<Text>(find.byType(Text));

      expect(textWidget.style?.fontSize, 14);
      expect(textWidget.style?.fontWeight, FontWeight.w100);
      expect(textWidget.style?.color, isNotNull); // AppColors.white
    });
  });
}
