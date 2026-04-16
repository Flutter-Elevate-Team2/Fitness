
import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/domain/repo/auth_repo_contract.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_use_case_test.mocks.dart';
@GenerateMocks([AuthRepoContract])
void main() {
late RegisterUseCase registerUseCase;
late MockAuthRepoContract mockAuthRepoContract;
setUpAll((){
  mockAuthRepoContract = MockAuthRepoContract();
  registerUseCase = RegisterUseCase(mockAuthRepoContract);
  provideDummy<BaseResponse<UserEntity>>(SuccessResponse<UserEntity>(data: UserEntity(
    id: "1",
    firstName: "John",
    lastName: "Doe",
    email: "[EMAIL_ADDRESS]",
    gender: "male",
    age: 25,
    weight: 70,
    height: 175,
    activityLevel: "active",
    goal: "lose weight",
    photo: "",
  )));

});
group("register use case", (){
  test("should return user entity when register successfully", ()async{
    //ARRANGE
    final mockParams = RegisterParams(
      firstName: "John",
      lastName: "Doe",
      email: "[EMAIL_ADDRESS]",
      password: "password",
      rePassword: "password",
      gender: "male",
      age: 25,
      weight: 70,
      height: 175,
      activityLevel: "active",
      goal: "lose weight",
    );
    final mockUserEntity = UserEntity(
      id: "1",
      firstName: "John",
      lastName: "Doe",
      email: "[EMAIL_ADDRESS]",
      gender: "male",
      age: 25,
      weight: 70,
      height: 175,
      activityLevel: "active",
      goal: "lose weight",
      photo: "",
    );
    final BaseResponse<UserEntity> tSuccessResponse = SuccessResponse<UserEntity>(data: mockUserEntity);
    when(mockAuthRepoContract.register(mockParams)).thenAnswer((_) async => tSuccessResponse);
    //ACT
    final result = await registerUseCase.register(mockParams);
    //ASSERT
    expect(result, tSuccessResponse);
    verify(mockAuthRepoContract.register(mockParams)).called(1);
    verifyNoMoreInteractions(mockAuthRepoContract);


  });
  test("should return error when register failed", ()async{
    //ARRANGE
    final mockParams = RegisterParams(
      firstName: "John",
      lastName: "Doe",
      email: "[EMAIL_ADDRESS]",
      password: "password",
      rePassword: "password",
      gender: "male",
      age: 25,
      weight: 70,
      height: 175,
      activityLevel: "active",
      goal: "lose weight",
    );
    final BaseResponse<UserEntity> tErrorResponse = ErrorResponse<UserEntity>(errorMessage: 'email already exists');
    when(mockAuthRepoContract.register(mockParams)).thenAnswer((_) async => tErrorResponse);
    //ACT
    final result = await registerUseCase.register(mockParams);
    //ASSERT
    expect(result, tErrorResponse);
    verify(mockAuthRepoContract.register(mockParams)).called(1);
    verifyNoMoreInteractions(mockAuthRepoContract);


  });



});


}
