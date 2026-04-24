import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'home_api.g.dart';

@RestApi()
@lazySingleton
abstract class HomeApi {
  @factoryMethod
  factory HomeApi(@Named("PrimaryDio") Dio dio ) = _HomeApi;
}
