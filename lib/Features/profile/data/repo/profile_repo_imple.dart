import 'dart:io';

import 'package:fitness_app/Features/profile/data/mapper/change_password_mapper.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';
import 'package:fitness_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/helpers/api_execution_mixin.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/profile/data/mapper/user_profile_mapper.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImple with ApiExecutionMixin implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;
  ProfileRepoImple(this._remoteDataSource);

  @override
  Future<BaseResponse<UserEntity>> getUserProfile() async {
    return execute<UserProfileResponse, UserEntity>(
      action: () async => await _remoteDataSource.getUserProfile(),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<ChangePasswordEntity>> changePassword(
    ChangePasswordRequest request,
  ) {
    return execute<ChangePasswordResponse, ChangePasswordEntity>(
      action: () async => await _remoteDataSource.changePassword(request),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<UserEntity>> editProfile(EditProfileRequest request) {
    return execute<UserProfileResponse, UserEntity>(
      action: () async => await _remoteDataSource.editProfile(request),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<String>> uploadPhoto(File file) async {
    return execute<UploadPhotoResponse, String>(
      action: () async => await _remoteDataSource.uploadPhoto(file),
      mapper: (response) => response.message,
    );
  }

  @override
  Future<BaseResponse<String>> logout() async {
    return execute<LogoutResponse, String>(
      action: () async => await _remoteDataSource.logout(),
      mapper: (response) => response.message,
    );
  }
}
