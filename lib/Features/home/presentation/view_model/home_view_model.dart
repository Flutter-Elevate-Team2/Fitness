import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import '../../../workouts/domain/entities/muscle_entity.dart';
import 'home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final GetMusclesByGroupIdUseCase _getMusclesByGroupUC;

  HomeViewModel(this._getHomeDataUseCase, this._getMusclesByGroupUC)
    : super(HomeState());

  void initHome() {
    emit(state.copyWith(isLoading: true));

    _getHomeDataUseCase.execute().listen(
      (sections) {
        emit(state.copyWith(homeData: sections, isLoading: false));
      },
      onError: (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      },
    );
  }

  void changeMuscleGroup(String groupId) async {
    final List<BaseResponse<HomeSection>> currentData = List.from(
      state.homeData,
    );

    int index = -1;
    UpcomingWorkoutsSectionData? oldSectionData;

    for (int i = 0; i < currentData.length; i++) {
      final item = currentData[i];
      if (item is SuccessResponse<HomeSection> &&
          item.data is UpcomingWorkoutsSectionData) {
        index = i;
        oldSectionData = item.data as UpcomingWorkoutsSectionData;
        break;
      }
    }

    if (index != -1 && oldSectionData != null) {
      currentData[index] = SuccessResponse(
        data: UpcomingWorkoutsSectionData(
          muscleGroups: oldSectionData.muscleGroups,
          currentGroupMuscles: [],
          selectedGroupId: groupId,
        ),
      );
      emit(state.copyWith(homeData: currentData));

      final result = await _getMusclesByGroupUC(groupId);

      if (result is SuccessResponse<List<MuscleEntity>>) {
        final List<BaseResponse<HomeSection>> finalData = List.from(
          state.homeData,
        );

        finalData[index] = SuccessResponse(
          data: UpcomingWorkoutsSectionData(
            muscleGroups: oldSectionData.muscleGroups,
            currentGroupMuscles: result.data,
            selectedGroupId: groupId,
          ),
        );
        emit(state.copyWith(homeData: finalData));
      }
    }
  }
}
