 import 'package:fitness_app/Features/profile/api/api_client/api_client.dart';
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


}
