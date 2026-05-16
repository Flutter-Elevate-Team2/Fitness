import 'dart:io';

import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';
import 'package:fitness_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<UserProfileResponse> getUserProfile();
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
  Future<LogoutResponse> logout();
  Future<UserProfileResponse> editProfile(EditProfileRequest request);
  Future<UploadPhotoResponse> uploadPhoto(File file);
}
