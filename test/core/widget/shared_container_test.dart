import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget widget) => MaterialApp(home: Scaffold(body: widget));

  group('SharedContainer Coverage Tests', () {
    testWidgets('should render child correctly', (tester) async {
      await tester.pumpWidget(
        wrap(const SharedContainer(child: Text('Inside Container'))),
      );

      expect(find.text('Inside Container'), findsOneWidget);
    });

    testWidgets('should apply BorderRadius.circular when isTopOnly is false', (
      tester,
    ) async {
      const double radius = 20;
      await tester.pumpWidget(
        wrap(
          const SharedContainer(
            borderRadius: radius,
            isTopOnly: false,
            child: SizedBox(),
          ),
        ),
      );

      final ClipRRect clipRRect = tester.widget(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(radius));

      final Container container = tester.widget(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(radius));
    });

    testWidgets('should apply BorderRadius.only when isTopOnly is true', (
      tester,
    ) async {
      const double radius = 40;
      await tester.pumpWidget(
        wrap(
          const SharedContainer(
            borderRadius: radius,
            isTopOnly: true,
            child: SizedBox(),
          ),
        ),
      );

      final ClipRRect clipRRect = tester.widget(find.byType(ClipRRect));
      final expectedRadius = BorderRadius.only(
        topLeft: const Radius.circular(radius),
        topRight: const Radius.circular(radius),
      );

      expect(clipRRect.borderRadius, expectedRadius);
    });

    testWidgets(
      'should use default blur and opacity values when not provided',
      (tester) async {
        await tester.pumpWidget(wrap(const SharedContainer(child: SizedBox())));

        final BackdropFilter backdropFilter = tester.widget(
          find.byType(BackdropFilter),
        );
        expect(backdropFilter.filter, isNotNull);

        final Container container = tester.widget(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, AppColors.blackSoft.withValues(alpha: 0.5));
      },
    );

    testWidgets('should apply custom blur and opacity values', (tester) async {
      const double customBlur = 20.0;
      const double customOpacity = 0.8;

      await tester.pumpWidget(
        wrap(
          const SharedContainer(
            blur: customBlur,
            opacity: customOpacity,
            child: SizedBox(),
          ),
        ),
      );

      final Container container = tester.widget(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(
        decoration.color,
        AppColors.blackSoft.withValues(alpha: customOpacity),
      );
    });

    testWidgets('should have correct internal padding', (tester) async {
      await tester.pumpWidget(wrap(const SharedContainer(child: SizedBox())));

      final Container container = tester.widget(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(24));
    });

    testWidgets('should apply default borderRadius when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const SharedContainer(child: SizedBox())));

      final ClipRRect clipRRect = tester.widget(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(30));
    });

    testWidgets('should verify ImageFilter properties (Full Coverage)', (
      tester,
    ) async {
      const double customBlur = 25.0;
      await tester.pumpWidget(
        wrap(const SharedContainer(blur: customBlur, child: SizedBox())),
      );

      final BackdropFilter backdropFilter = tester.widget(
        find.byType(BackdropFilter),
      );

      expect(backdropFilter.filter.toString(), contains('25.0'));

      await tester.pumpWidget(wrap(const SharedContainer(child: SizedBox())));
      final BackdropFilter defaultFilter = tester.widget(
        find.byType(BackdropFilter),
      );
      expect(defaultFilter.filter.toString(), contains('15.0'));
    });
  });
}
