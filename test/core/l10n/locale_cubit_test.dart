import 'package:fitness_app/core/l10n/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('LocaleCubit Tests', () {

     test('initial state is English (en)', () {
      final localeCubit = LocaleCubit();
      expect(localeCubit.state, const Locale('en'));
      localeCubit.close();
    });

     blocTest<LocaleCubit, Locale>(
      'emits [Locale(ar)] when toggleLanguage is called with false',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.toggleLanguage(false),
      expect: () => [const Locale('ar')],
    );

    blocTest<LocaleCubit, Locale>(
      'emits [Locale(en)] when toggleLanguage is called with true',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.toggleLanguage(true),
      expect: () => [const Locale('en')],
    );

     blocTest<LocaleCubit, Locale>(
      'emits [Locale(ar), Locale(en)] when toggled twice',
      build: () => LocaleCubit(),
      act: (cubit) {
        cubit.toggleLanguage(false);
        cubit.toggleLanguage(true);
      },
      expect: () => [
        const Locale('ar'),
        const Locale('en'),
      ],
    );
  });
}