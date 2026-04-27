 import 'package:fitness_app/Features/profile/api/api_client/api_client.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_response/change_password_response.dart';
import 'package:fitness_app/Features/profile/data/models/logout_response.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImple implements ProfileRemoteDataSourceContract {
  final ProfileApi _api;
  @factoryMethod
  ProfileRemoteDataSourceImple(this._api);


  @override
  Future<UserProfileResponse> getUserProfile() async {
    return await _api.getUserProfile();
  }
  @override
  Future<UserProfileResponse> editProfile(EditProfileRequest request) async {
    return await _api.editProfile(request);
  }

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) {
    return _api.changePassword(request);
  }


  @override
  Future<LogoutResponse> logout() async {
    return await _api.logout();
  }

}
