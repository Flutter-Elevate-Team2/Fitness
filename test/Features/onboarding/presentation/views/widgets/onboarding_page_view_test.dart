import 'package:fitness_app/Features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_event.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_page_view.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_action_buttons_test.mocks.dart';

void main() {
  late MockOnboardingViewModel mockViewModel;
  late PageController pageController;

  final List<OnboardingEntity> testPages = [
    OnboardingEntity(title: 'Title 1', description: 'Desc 1', image: 'Img 1'),
    OnboardingEntity(title: 'Title 2', description: 'Desc 2', image: 'Img 2'),
  ];

  setUp(() {
    mockViewModel = MockOnboardingViewModel();
    pageController = PageController();

    when(mockViewModel.state).thenReturn(const OnboardingState());
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<OnboardingViewModel>.value(
          value: mockViewModel,
          child: OnboardingPageView(
            pageController: pageController,
            pages: testPages,
          ),
        ),
      ),
    );
  }

  group('OnboardingPageView Tests', () {
    testWidgets('should render PageView with correct number of items', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(PageView), findsOneWidget);

      expect(find.byType(OnboardingContentWidget), findsOneWidget);
      expect(find.text('Title 1'), findsOneWidget);
    });

    testWidgets(
      'should call doIntent with OnboardingPageChangedEvent when swiped',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        verify(
          mockViewModel.doIntent(argThat(isA<OnboardingPageChangedEvent>())),
        ).called(1);
      },
    );

    testWidgets('should have correct height based on MediaQuery', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 170.0);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
