import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class HomeFactory {
  Stream<BaseResponse<List<RandomMusclesEntity>>> getRandomMuscles();
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups();
  Future <BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(String id);
  Stream<BaseResponse<List<CategoryEntity>>> getFoodCategories();
}