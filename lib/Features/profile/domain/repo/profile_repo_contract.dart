import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class ProfileRepoContract {
 Future<BaseResponse<UserEntity>> getUserProfile();
 }

