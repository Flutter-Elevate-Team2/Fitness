import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'workouts_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class WorkoutsApi {
  @factoryMethod
  factory WorkoutsApi(Dio dio) = _WorkoutsApi;
}
