import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';

class WorkoutsStates {
  final BaseState<List<MuscleGroupEntity>> muscleGroupsState;
  final BaseState<List<MuscleEntity>> musclesState;

  WorkoutsStates({
    this.muscleGroupsState = const BaseState(),
    this.musclesState = const BaseState(),
  });

  WorkoutsStates copyWith({
    BaseState<List<MuscleGroupEntity>>? muscleGroupsState,
    BaseState<List<MuscleEntity>>? musclesState,
  }) {
    return WorkoutsStates(
      muscleGroupsState: muscleGroupsState ?? this.muscleGroupsState,
      musclesState: musclesState ?? this.musclesState,
    );
  }
}
