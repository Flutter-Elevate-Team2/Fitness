import 'package:dio/dio.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscle_groups_response.dart';
import 'package:fitness_app/Features/workouts/data/models/responses/muscles_by_group_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'workouts_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class WorkoutsApi {
  @factoryMethod
  factory WorkoutsApi(@Named("PrimaryDio") Dio dio) = _WorkoutsApi;

  @GET(ApiConstants.muscles)
  Future<MuscleGroupsResponse> getMuscleGroups();

  @GET(ApiConstants.musclesByGroup)
  Future<MusclesByGroupResponse> getMusclesByGroupId(@Path("id") String id);
}
