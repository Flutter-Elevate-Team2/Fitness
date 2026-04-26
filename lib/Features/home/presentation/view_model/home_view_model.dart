import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart'; // تأكدي من المسار
import 'package:fitness_app/core/base_response/base_response.dart';
import 'home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeViewModel(this._getHomeDataUseCase) : super(HomeState());

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

  /// الدالة المسؤولة عن تغيير الـ Tab في سكشن Upcoming Workouts
  void changeMuscleGroup(String groupId) async {
    final List<BaseResponse<HomeSection>> updatedData = List.from(
      state.homeData,
    );

    final sectionIndex = updatedData.indexWhere(
      (response) =>
          response is SuccessResponse<HomeSection> &&
          response.data is UpcomingWorkoutsSectionData,
    );

    if (sectionIndex != -1) {
      final oldSuccess =
          updatedData[sectionIndex] as SuccessResponse<HomeSection>;
      final oldSection = oldSuccess.data as UpcomingWorkoutsSectionData;

      updatedData[sectionIndex] = SuccessResponse(
        data: UpcomingWorkoutsSectionData(
          muscleGroups: oldSection.muscleGroups,
          currentGroupMuscles: [],
          selectedGroupId: groupId,
        ),
      );

      emit(state.copyWith(homeData: updatedData));
    }
  }
}
