import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';

sealed class HomeSection {
  final int index;
  HomeSection(this.index);
}

class RandomMuscleSection extends HomeSection {
  final List<RandomMusclesEntity> muscles;
  RandomMuscleSection(this.muscles) : super(0); // Index 0
}

class UpcomingWorkoutsSectionData extends HomeSection {
  final List<MuscleGroupEntity> muscleGroups;
  final List<MuscleEntity> currentGroupMuscles;
  final String? selectedGroupId;

  UpcomingWorkoutsSectionData({
    required this.muscleGroups,
    required this.currentGroupMuscles,
    this.selectedGroupId,
  }) : super(1); // Index 1
}

class FoodCategoriesSection extends HomeSection {
  final List<CategoryEntity> categories;
  FoodCategoriesSection(this.categories) : super(2); // Index 2
}

class PopularWorkoutsSection extends HomeSection {
  final List<PopularWorkoutEntity> workouts;
  PopularWorkoutsSection(this.workouts) : super(3); // Index 3
}
