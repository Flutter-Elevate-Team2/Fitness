import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'food_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class FoodApi {
  @factoryMethod
  factory FoodApi(@Named("MealsDio") Dio dio) = _FoodApi;
}
