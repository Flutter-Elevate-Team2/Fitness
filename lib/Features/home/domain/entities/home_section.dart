import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';

import '../../../profile/domain/entities/user_entity.dart';

sealed class HomeSection {
  final int index;
  HomeSection(this.index);
}

class UserProfileSection extends HomeSection {
  final UserEntity user;
  UserProfileSection(this.user) : super(0);
}

class FoodCategoriesSection extends HomeSection {
  final List<CategoryEntity> categories;
  FoodCategoriesSection(this.categories) : super(1);
}

class UpcomingWorkoutsSectionData extends HomeSection {
  final List<MuscleGroupEntity> muscleGroups;
  final List<MuscleEntity> currentGroupMuscles;
  final String? selectedGroupId;

  UpcomingWorkoutsSectionData({
    required this.muscleGroups,
    required this.currentGroupMuscles,
    this.selectedGroupId,
  }) : super(2);
}

class RandomMuscleSection extends HomeSection {
  final List<RandomMusclesEntity> muscles;
  RandomMuscleSection(this.muscles) : super(3);
}

class PopularWorkoutsSection extends HomeSection {
  final List<PopularWorkoutEntity> workouts;
  PopularWorkoutsSection(this.workouts) : super(4);
}

