
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';

extension UserProfileMapper on UserProfileResponse {
  UserEntity toEntity() {
    final userData = user;

    return UserEntity(
      id: userData?.id ?? '',
      firstName: userData?.firstName ?? '',
      lastName: userData?.lastName ?? '',
      email: userData?.email ?? '',
       photo: userData?.photo ?? '',
       gender: userData?.gender ?? '',
       age: userData?.age ?? 0,
       weight: userData?.weight ?? 0,
       height: userData?.height ?? 0,
       activityLevel: userData?.activityLevel ?? '',
       goal: userData?.goal ?? '',
    );
  }
}
