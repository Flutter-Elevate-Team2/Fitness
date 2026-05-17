import 'package:fitness_app/Features/auth/data/mappers/register_mappers.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/data/models/register_response/user.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModelMapper - toEntity()', () {
    test(
      'should correctly map a fully-populated RegisterResponse to a UserEntity',
      () {
        // ARRANGE
        final tUser = User(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          gender: 'male',
          age: 25,
          weight: 70,
          height: 175,
          activityLevel: 'active',
          goal: 'lose weight',
          photo: 'https://example.com/photo.jpg',
        );
        final tRegisterResponse = RegisterResponse(
          message: 'success',
          user: tUser,
          token: 'some_token',
        );
        final tExpectedEntity = UserEntity(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          gender: 'male',
          age: 25,
          weight: 70,
          height: 175,
          activityLevel: 'active',
          goal: 'lose weight',
          photo: 'https://example.com/photo.jpg',
        );

        // ACT
        final result = tRegisterResponse.toEntity();

        // ASSERT
        expect(result, tExpectedEntity);
      },
    );

    test(
      'should use fallback value "Unknown" for firstName when it is null',
      () {
        // ARRANGE
        final tUser = User(
          id: '1',
          firstName: null, // Simulating a null firstName from the API
          lastName: 'Doe',
          email: 'john.doe@example.com',
          gender: 'male',
          age: 25,
          weight: 70,
          height: 175,
          activityLevel: 'active',
          goal: 'lose weight',
          photo: '',
        );
        final tRegisterResponse = RegisterResponse(user: tUser, token: 'token');

        // ACT
        final result = tRegisterResponse.toEntity();

        // ASSERT
        expect(result.firstName, 'Unknown');
      },
    );

    test(
      'should use empty string fallbacks for all nullable String fields when they are null',
      () {
        final tUser = User(
          id: null,
          firstName: null,
          lastName: null,
          email: null,
          gender: null,
          age: null,
          weight: null,
          height: null,
          activityLevel: null,
          goal: null,
          photo: null,
        );
        final tRegisterResponse = RegisterResponse(user: tUser);

        // ACT
        final result = tRegisterResponse.toEntity();

        // ASSERT
        expect(result.firstName, 'Unknown');
        expect(result.id, '');
        expect(result.lastName, '');
        expect(result.email, '');
        expect(result.gender, '');
        expect(result.activityLevel, '');
        expect(result.goal, '');
        expect(result.photo, '');
        expect(result.age, 0);
        expect(result.weight, 0);
        expect(result.height, 0);
      },
    );

    test(
      'should use zero (0) as fallback for all nullable numeric fields when they are null',
      () {
        // ARRANGE
        final tUser = User(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          gender: 'male',
          age: null,
          weight: null,
          height: null,
          activityLevel: 'active',
          goal: 'lose weight',
          photo: '',
        );
        final tRegisterResponse = RegisterResponse(user: tUser, token: 'token');

        // ACT
        final result = tRegisterResponse.toEntity();

        // ASSERT
        expect(result.age, 0);
        expect(result.weight, 0);
        expect(result.height, 0);
      },
    );

    test(
      'should map all fields to their default/fallback values when the user object itself is null',
      () {
        final tRegisterResponse = RegisterResponse(
          message: 'success',
          user: null, // The entire user object is null
          token: 'some_token',
        );

        // ACT
        final result = tRegisterResponse.toEntity();

        // ASSERT
        expect(result.id, '');
        expect(result.firstName, 'Unknown');
        expect(result.lastName, '');
        expect(result.email, '');
        expect(result.gender, '');
        expect(result.age, 0);
        expect(result.weight, 0);
        expect(result.height, 0);
        expect(result.activityLevel, '');
        expect(result.goal, '');
        expect(result.photo, '');
      },
    );
  });
}
