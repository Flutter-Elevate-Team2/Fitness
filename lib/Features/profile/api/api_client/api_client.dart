import 'package:dio/dio.dart';
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

  
}
