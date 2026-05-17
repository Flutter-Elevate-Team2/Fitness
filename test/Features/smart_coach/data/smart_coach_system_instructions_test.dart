import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/data/smart_coach_system_instructions.dart';

void main() {
  group('SmartCoachSystemInstructions', () {
    test('systemPrompt should be a non-empty string', () {
      expect(SmartCoachSystemInstructions.systemPrompt, isNotEmpty);
    });

    test('systemPrompt should mention fitness and nutrition scope', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt.toLowerCase(), contains('fitness'));
      expect(prompt.toLowerCase(), contains('nutrition'));
    });

    test('systemPrompt should include role description', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt, contains('Your Role'));
    });

    test('systemPrompt should include core rules and constraints', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt, contains('Core Rules'));
    });

    test('systemPrompt should include out-of-scope handling', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt, contains('Out-of-Scope'));
    });

    test('systemPrompt should include medical disclaimer', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt, contains('Medical Disclaimer'));
    });

    test('systemPrompt should include dynamic language matching', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt, contains('Dynamic Language Matching'));
    });

    test('systemPrompt should include Arabic fallback message', () {
      final prompt = SmartCoachSystemInstructions.systemPrompt;
      expect(prompt, contains('عذراً'));
    });
  });
}
