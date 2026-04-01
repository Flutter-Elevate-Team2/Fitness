import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseState Unit Tests', () {
    test('Initial values should be correct', () {
      const state = BaseState<String>();

      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(state.data, isNull);
    });

    test('copyWith should update fields correctly', () {
      const state = BaseState<String>();

      final updatedState = state.copyWith(
        isLoading: true,
        errorMessage: 'Error',
        data: 'Done',
      );

      expect(updatedState.isLoading, true);
      expect(updatedState.errorMessage, 'Error');
      expect(updatedState.data, 'Done');
    });

    test('copyWith should keep old values if null is passed', () {
      const state = BaseState<String>(isLoading: true, data: 'Old Data');

      final updatedState = state.copyWith(errorMessage: 'New Error');

      expect(updatedState.isLoading, true);
      expect(updatedState.data, 'Old Data');
      expect(updatedState.errorMessage, 'New Error');
    });

    test('Equality test (Equatable)', () {
      const state1 = BaseState<int>(isLoading: true, data: 10);
      const state2 = BaseState<int>(isLoading: true, data: 10);
      const state3 = BaseState<int>(isLoading: false, data: 10);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
    test('props should contain all fields in order', () {
      const state = BaseState<int>(
        isLoading: true,
        errorMessage: 'failed',
        data: 5,
      );

      expect(state.props, [true, 'failed', 5]);
    });

    test(
      'copyWith should return exact same values if no arguments are provided',
          () {
        const state = BaseState<int>(isLoading: true, data: 10);
        final result = state.copyWith();

        expect(result, equals(state));
      },
    );
  });
}
