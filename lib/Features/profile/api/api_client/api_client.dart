import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';
import 'package:fitness_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApi {
  @factoryMethod
  factory ProfileApi(@Named("PrimaryDio") Dio dio) = _ProfileApi;

  @GET(ApiConstants.getUserProfile)
  Future<UserProfileResponse> getUserProfile();

  @GET(ApiConstants.logout)
  Future<LogoutResponse> logout();

  @PUT(ApiConstants.editProfile)
  Future<UserProfileResponse> editProfile(@Body() EditProfileRequest request);

  @PUT(ApiConstants.uploadPhoto)
  @MultiPart()
  Future<UploadPhotoResponse> uploadPhoto(@Part(name: "photo") File photo);

  @PATCH(ApiConstants.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest request,
  );
}
