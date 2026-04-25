import 'package:equatable/equatable.dart'; // 👈 ضيف الامبورت ده
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import '../../../profile/domain/entities/user_entity.dart';

class HomeState extends Equatable {
  final UserEntity? user;
  final List<RandomMusclesEntity> randomMuscles;
  final List<MuscleGroupEntity> muscleGroups;
  final List<MuscleEntity> currentGroupMuscles;
  final List<CategoryEntity> foodCategories;
  final String? selectedGroupId;
  final bool isLoading;
  final BaseState<List<PopularWorkoutEntity>> popularWorkoutsState;

  const HomeState({
    this.user,
    this.randomMuscles = const [],
    this.muscleGroups = const [],
    this.currentGroupMuscles = const [],
    this.foodCategories = const [],
    this.selectedGroupId,
    this.isLoading = false,
    this.popularWorkoutsState = const BaseState(),
  });

  HomeState copyWith({
    UserEntity? user,
    List<RandomMusclesEntity>? randomMuscles,
    List<MuscleGroupEntity>? muscleGroups,
    List<MuscleEntity>? currentGroupMuscles,
    List<CategoryEntity>? foodCategories,
    String? selectedGroupId,
    bool? isLoading,
    BaseState<List<PopularWorkoutEntity>>? popularWorkoutsState,
  }) {
    return HomeState(
      user: user ?? this.user,
      randomMuscles: randomMuscles ?? this.randomMuscles,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      currentGroupMuscles: currentGroupMuscles ?? this.currentGroupMuscles,
      foodCategories: foodCategories ?? this.foodCategories,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      isLoading: isLoading ?? this.isLoading,
      popularWorkoutsState: popularWorkoutsState ?? this.popularWorkoutsState,
    );
  }

  @override
  List<Object?> get props => [
        user,
        randomMuscles,
        muscleGroups,
        currentGroupMuscles,
        foodCategories,
        selectedGroupId,
        isLoading,
        popularWorkoutsState,
      ];
}
