
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';

abstract class ProfileRemoteDataSourceContract {

    Future<UserProfileResponse> getUserProfile();


}