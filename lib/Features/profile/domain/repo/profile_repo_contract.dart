import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class ProfileRepoContract {
 Future<BaseResponse<UserEntity>> getUserProfile();
 Future<BaseResponse<UserEntity>> editProfile(EditProfileRequest request);
 Future<BaseResponse<ChangePasswordEntity>> changePassword(ChangePasswordRequest request);
 Future<BaseResponse<String>> logout();
 }

