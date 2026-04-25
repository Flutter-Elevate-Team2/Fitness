import 'package:fitness_app/Features/profile/api/api_client/api_client.dart';
import 'package:fitness_app/Features/profile/api/remot_data_source_imple/profile_remote_data_source_imple.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProfileApi])
import 'profile_remote_data_source_imple_test.mocks.dart';

void main() {
  late ProfileRemoteDataSourceImple dataSource;
  late MockProfileApi mockApi;

  setUp(() {
    mockApi = MockProfileApi();
    dataSource = ProfileRemoteDataSourceImple(mockApi);
  });


  // ---------------------------------------------------------------------------
  // getUserProfile
  // ---------------------------------------------------------------------------
  group('getUserProfile', () {
    final response = UserProfileResponse(
      message: 'Success',
      user: User(id: '1', firstName: 'John'),
    );

    test(
      'delegates to ProfileApi.getUserProfile and returns the response',
      () async {
        when(mockApi.getUserProfile()).thenAnswer((_) async => response);

        final result = await dataSource.getUserProfile();

        expect(result, response);
        verify(mockApi.getUserProfile()).called(1);
      },
    );

    test('throws when ProfileApi.getUserProfile throws', () async {
      when(mockApi.getUserProfile()).thenThrow(Exception('Not found'));

      expect(() => dataSource.getUserProfile(), throwsException);
    });
  });

}
