import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget(SharedAuthLayout layout) {
    return MaterialApp(home: layout);
  }

  group('SharedAuthLayout Widget Tests', () {
    testWidgets('should render title, subtitle and button text correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'Title Test',
            subtitle: 'Subtitle Test',
            buttonTitle: 'Confirm',
            showBackButton: true,
            formBody: SizedBox(),
          ),
        ),
      );

      expect(find.text('Title Test'), findsOneWidget);
      expect(find.text('Subtitle Test'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('should show stepIndicator when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'T',
            subtitle: 'S',
            buttonTitle: 'B',
            showBackButton: true,
            stepIndicator: KeyedSubtree(
              key: Key('step_indicator'),
              child: SizedBox(),
            ),
            formBody: SizedBox(),
          ),
        ),
      );

      expect(find.byKey(const Key('step_indicator')), findsOneWidget);
    });

    testWidgets('should show underButtonWidget when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'T',
            subtitle: 'S',
            buttonTitle: 'B',
            showBackButton: true,
            underButtonWidget: Text('Under Button'),
            formBody: SizedBox(),
          ),
        ),
      );

      expect(find.text('Under Button'), findsOneWidget);
    });

    testWidgets('should toggle styles based on isGreeting', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'BIG TITLE',
            subtitle: 'small subtitle',
            buttonTitle: 'B',
            showBackButton: true,
            isGreeting: false,
            formBody: SizedBox(),
          ),
        ),
      );

      Text titleText = tester.widget(find.text('BIG TITLE'));
      expect(titleText.style!.fontSize, isNot(16));

      // Test when isGreeting is true
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'Small Greeting',
            subtitle: 'BIG TITLE',
            buttonTitle: 'B',
            showBackButton: true,
            isGreeting: true,
            formBody: SizedBox(),
          ),
        ),
      );

      Text greetingText = tester.widget(find.text('Small Greeting'));
      expect(greetingText.style!.fontWeight, FontWeight.normal);
    });

    testWidgets('should call onButtonPressed when button is clicked', (
      tester,
    ) async {
      bool isClicked = false;
      await tester.pumpWidget(
        createTestWidget(
          SharedAuthLayout(
            title: 'T',
            subtitle: 'S',
            buttonTitle: 'Click Me',
            showBackButton: true,
            onButtonPressed: () => isClicked = true,
            formBody: SizedBox(),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(isClicked, true);
    });

    testWidgets('should verify layout components are present', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'T',
            subtitle: 'S',
            buttonTitle: 'B',
            showBackButton: true,
            formBody: SizedBox(key: Key('form_body')),
          ),
        ),
      );

      expect(find.byType(SharedScaffold), findsOneWidget);
      expect(find.byType(SharedContainer), findsOneWidget);
      expect(find.byKey(const Key('form_body')), findsOneWidget);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should not render SharedScaffold when useScaffold is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const SharedAuthLayout(
            title: 'T',
            subtitle: 'S',
            buttonTitle: 'B',
            showBackButton: true,
            useScaffold: false,
            formBody: SizedBox(),
          ),
        ),
      );

      expect(find.byType(SharedScaffold), findsNothing);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
