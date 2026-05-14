import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomProfileField Widget Tests', () {
    testWidgets('renders and displays hint text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomProfileField(
              hintText: 'Enter your name',
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('triggers onChanged callback when user types', (
      WidgetTester tester,
    ) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomProfileField(
              controller: TextEditingController(),
              onChanged: () {
                changedValue = 'updated';
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'New Text');
      await tester.pumpAndSettle();

      expect(changedValue, 'updated');
    });

    testWidgets('executes validator correctly', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomProfileField(
                controller: TextEditingController(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState?.validate();

      await tester.pump();

      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
