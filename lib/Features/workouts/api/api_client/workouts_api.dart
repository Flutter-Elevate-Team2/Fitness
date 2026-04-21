import 'package:dio/dio.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_response.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercises_response.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'workouts_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class WorkoutsApi {
  @factoryMethod
  factory WorkoutsApi(@Named("PrimaryDio") Dio dio ) = _WorkoutsApi;

  @GET(ApiConstants.difficultyLevelsByPrimeMover)
  Future<DifficultyLevelResponse> getDifficultyLevelsByPrimeMover(
    @Query("primeMoverMuscleId") String primeMoverMuscleId,
  );
  @GET(ApiConstants.exercisesByMuscleDifficulty)
  Future<ExercisesResponse> getExercisesByMuscleDifficulty(
    @Query("primeMoverMuscleId") String primeMoverMuscleId,
    @Query("difficultyLevelId") String difficultyLevelId,
     @Query("page") int page,
  );
}
