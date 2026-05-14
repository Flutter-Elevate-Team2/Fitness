import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/login_use_cases/valid_token_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'valid_token_use_case_test.mocks.dart';

@GenerateMocks([AuthLocalDataSourceContract])
void main() {
  late HasValidTokenUseCase useCase;
  late MockAuthLocalDataSourceContract mockLocal;

  setUp(() {
    mockLocal = MockAuthLocalDataSourceContract();
    useCase = HasValidTokenUseCase(mockLocal);
  });

  test('should return true when token exists and not empty', () async {
    when(mockLocal.getToken()).thenAnswer((_) async => 'abc123');

    final result = await useCase();

    expect(result, true);
    verify(mockLocal.getToken()).called(1);
  });

  test('should return false when token is null', () async {
    when(mockLocal.getToken()).thenAnswer((_) async => null);

    final result = await useCase();

    expect(result, false);
    verify(mockLocal.getToken()).called(1);
  });

  test('should return false when token is empty', () async {
    when(mockLocal.getToken()).thenAnswer((_) async => '');

    final result = await useCase();

    expect(result, false);
    verify(mockLocal.getToken()).called(1);
  });
}
