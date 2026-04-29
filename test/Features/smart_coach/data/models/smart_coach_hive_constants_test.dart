import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/Features/smart_coach/data/models/smart_coach_hive_constants.dart';

void main() {
  group('SmartCoachHiveConstants', () {
    test('sessionsBoxName should have correct value', () {
      expect(SmartCoachHiveConstants.sessionsBoxName, 'smart_coach_sessions');
    });

    test('sessionsBoxName should be a non-empty string', () {
      expect(SmartCoachHiveConstants.sessionsBoxName, isNotEmpty);
    });
  });
}
