import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'workouts_events.dart';
import 'workouts_states.dart';

@injectable
class WorkoutsViewModel extends Cubit<WorkoutsStates> {
  final GetMuscleGroupsUseCase _getMuscleGroupsUseCase;
  final GetMusclesByGroupIdUseCase _getMusclesByGroupIdUseCase;

  WorkoutsViewModel(
    this._getMuscleGroupsUseCase,
    this._getMusclesByGroupIdUseCase,
  ) : super(WorkoutsStates());

  void doIntent(WorkoutsEvent event) {
    switch (event) {
      case FetchMuscleGroupsEvent():
        _fetchMuscleGroups();
        break;
      case FetchMusclesByGroupEvent():
        _fetchMusclesByGroup(event.groupId);
        break;
    }
  }

  Future<void> _fetchMuscleGroups() async {
    emit(state.copyWith(
      muscleGroupsState: state.muscleGroupsState.copyWith(isLoading: true),
    ));

    final response = await _getMuscleGroupsUseCase();

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(
          muscleGroupsState: state.muscleGroupsState.copyWith(
            isLoading: false,
            data: response.data,
            errorMessage: null,
          ),
        ));
        break;
      case ErrorResponse():
        emit(state.copyWith(
          muscleGroupsState: state.muscleGroupsState.copyWith(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ));
        break;
    }
  }

  Future<void> _fetchMusclesByGroup(String groupId) async {
    emit(state.copyWith(
      musclesState: state.musclesState.copyWith(isLoading: true),
    ));

    final response = await _getMusclesByGroupIdUseCase(groupId);

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(
          musclesState: state.musclesState.copyWith(
            isLoading: false,
            data: response.data,
            errorMessage: null,
          ),
        ));
        break;
      case ErrorResponse():
        emit(state.copyWith(
          musclesState: state.musclesState.copyWith(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ));
        break;
    }
  }
}
