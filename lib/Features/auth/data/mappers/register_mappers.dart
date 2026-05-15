
import 'package:fitness_app/Features/auth/data/models/register_response/register_response.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';

extension UserModelMapper on RegisterResponse {
  UserEntity toEntity() {
    return UserEntity(
      id: user?.id ?? '',
      firstName: user?.firstName ?? 'غير محدد',
      lastName: user?.lastName ?? '',
      email: user?.email ?? '',
      gender: user?.gender ?? '',
      age: user?.age ?? 0,
      weight: user?.weight ?? 0,
      height: user?.height ?? 0,
      activityLevel: user?.activityLevel ?? '',
      goal: user?.goal ?? '',
      photo: user?.photo ?? '',
    );
  }
}
