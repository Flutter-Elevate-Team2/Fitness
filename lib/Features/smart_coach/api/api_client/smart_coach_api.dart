import 'package:dio/dio.dart';
import 'package:fitness_app/Features/smart_coach/data/models/responses/smart_coach_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'smart_coach_api.g.dart';

@RestApi()
@lazySingleton
abstract class SmartCoachApi {
  @factoryMethod
  factory SmartCoachApi(@Named("PrimaryDio") Dio dio) = _SmartCoachApi;

  @GET('/smart-coach/data')
  Future<SmartCoachResponse> getSmartCoachData();
}
