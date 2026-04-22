import 'package:fitness_app/Features/workouts/presentation/views/widgets/tabs/workouts_tabs_error.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(height: 48, child: child),
      ),
    );
  }

  group('WorkoutsTabsError', () {
    testWidgets('renders the provided error message', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const WorkoutsTabsError(errorMessage: 'Connection timed out'),
        ),
      );

      expect(find.text('Connection timed out'), findsOneWidget);
    });

    testWidgets('applies red text color', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const WorkoutsTabsError(errorMessage: 'Error'),
        ),
      );

      final text = tester.widget<Text>(find.text('Error'));
      expect(text.style?.color, AppColors.red);
    });

    testWidgets('is centered with horizontal padding', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const WorkoutsTabsError(errorMessage: 'Error'),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });
  });
}
