import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget widget) => MaterialApp(home: Scaffold(body: widget));

  group('CustomButton Coverage Tests', () {
    testWidgets('should render title and respond to tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        wrap(CustomButton(title: 'Click Me', onPressed: () => pressed = true)),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });

    testWidgets('should show border when hasBorder is true', (tester) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            title: 'Border Button',
            onPressed: () {},
            hasBorder: true,
            borderColor: Colors.red,
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      final BorderSide? side = button.style?.side?.resolve({});
      expect(side?.color, Colors.red);
    });

    testWidgets(
      'should show default primary border when hasBorder is true and borderColor is null',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            CustomButton(
              title: 'Default Border',
              onPressed: () {},
              hasBorder: true,
            ),
          ),
        );

        final ElevatedButton button = tester.widget(
          find.byType(ElevatedButton),
        );
        final BorderSide? side = button.style?.side?.resolve({});
        expect(side?.color, AppColors.primary);
      },
    );

    testWidgets('should apply special styling when backgroundColor is white', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            title: 'White Button',
            onPressed: () {},
            backgroundColor: AppColors.white,
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      final BorderSide? side = button.style?.side?.resolve({});
      expect(side?.color, AppColors.light400);

      final Text text = tester.widget(find.text('White Button'));
      expect(text.style?.color, AppColors.primary);
    });

    testWidgets('should handle disabled state and default disabled colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const CustomButton(title: 'Disabled', onPressed: null)),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      final Color? bgColor = button.style?.backgroundColor?.resolve({
        WidgetState.disabled,
      });
      final Color? fgColor = button.style?.foregroundColor?.resolve({
        WidgetState.disabled,
      });

      expect(bgColor, AppColors.light400);
      expect(fgColor, AppColors.white);

      final BorderSide? side = button.style?.side?.resolve({
        WidgetState.disabled,
      });
      expect(side, isNull);
    });

    testWidgets('should apply custom disabled colors if provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const CustomButton(
            title: 'Custom Disabled',
            onPressed: null,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.black,
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      final Color? bgColor = button.style?.backgroundColor?.resolve({
        WidgetState.disabled,
      });
      final Color? fgColor = button.style?.foregroundColor?.resolve({
        WidgetState.disabled,
      });

      expect(bgColor, Colors.grey);
      expect(fgColor, Colors.black);
    });

    testWidgets(
      'should show border when not disabled and background is white (else branch)',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            CustomButton(
              title: 'White BG',
              onPressed: () {},
              backgroundColor: AppColors.white,
            ),
          ),
        );

        final ElevatedButton button = tester.widget(
          find.byType(ElevatedButton),
        );
        final BorderSide? side = button.style?.side?.resolve({});
        expect(side, isNotNull);
        expect(side?.color, AppColors.light400);
      },
    );

    testWidgets('should have circular border radius of 100', (tester) async {
      await tester.pumpWidget(
        wrap(CustomButton(title: 'Radius', onPressed: () {})),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({}) as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(100));
    });
  });
}
