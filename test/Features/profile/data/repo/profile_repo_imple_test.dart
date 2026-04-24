 import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/Features/profile/data/repo/profile_repo_imple.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
import 'profile_repo_imple_test.mocks.dart';

void main() {
  late ProfileRepoImple repo;
  late MockProfileRemoteDataSourceContract mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSourceContract();
    repo = ProfileRepoImple(mockRemoteDataSource);
  });

  // ---------------------------------------------------------------------------
  // getUserProfile
  // ---------------------------------------------------------------------------
  group('getUserProfile', () {
    final userModel = User(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
       photo: '',
       gender: 'male',
       age: 20,
      weight:  70,
      height: 170,
      activityLevel: 'Intermediate',
      goal: 'Lose Weight',
    );

    final response = UserProfileResponse(
      message: 'Success',
      user: userModel,
    );

    test('returns SuccessResponse<userEntity> when succeeds', () async {
      when(
        mockRemoteDataSource.getUserProfile(),
      ).thenAnswer((_) async => response);

      final result = await repo.getUserProfile();

      expect(result, isA<SuccessResponse<UserEntity>>());
      final data = (result as SuccessResponse<UserEntity>).data;
      expect(data.id, '1');
      expect(data.firstName, 'John');
      verify(mockRemoteDataSource.getUserProfile()).called(1);
    });

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.getUserProfile(),
      ).thenThrow(Exception('Server error'));

      final result = await repo.getUserProfile();

      expect(result, isA<ErrorResponse<UserEntity>>());
    });
  });


}
