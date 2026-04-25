import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/domain/factory/home_factory.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_popular_workouts_use_case.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeFactory)
class HomeFactoryImpl implements HomeFactory {
  final GetMuscleGroupsUseCase _muscleGroupsUC;
  final GetRandomMusclesUseCase _randomMusclesUC;
  final GetCategoriesUseCase _foodUC;
  final GetMusclesByGroupIdUseCase _musclesByGroupIdUC;
  final GetUserProfileUseCase _profileUC;
  final GetPopularWorkoutsUseCase _popularWorkoutsUC;

  HomeFactoryImpl(
    this._muscleGroupsUC,
    this._randomMusclesUC,
    this._foodUC,
    this._musclesByGroupIdUC,
    this._profileUC,
    this._popularWorkoutsUC,
  );

  @override
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups() =>
      _muscleGroupsUC();

  @override
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(String id) {
    return _musclesByGroupIdUC(id);
  }

  @override
  Stream<BaseResponse<List<RandomMusclesEntity>>> getRandomMuscles() async* {
    final result = await _randomMusclesUC();
    yield result;
  }

  @override
  Stream<BaseResponse<List<CategoryEntity>>> getFoodCategories() async* {
    final result = await _foodUC();
    yield result;
  }

  @override
  Stream<BaseResponse<UserEntity>> getUserData() async* {
    final result = await _profileUC();
    yield result;
  }

  @override
  Stream<BaseResponse<List<PopularWorkoutEntity>>> getPopularWorkouts() {
    return _popularWorkoutsUC();
  }
}
