import 'package:dio/dio.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'home_api.g.dart';

@RestApi()
@lazySingleton
abstract class HomeApi {
  @factoryMethod
  factory HomeApi(@Named("PrimaryDio") Dio dio ) = _HomeApi;
    @GET(ApiConstants.levels)
  Future<LevelsRespones> getLevels();
}
