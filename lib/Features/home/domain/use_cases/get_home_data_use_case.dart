import 'dart:async';
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/food/domain/use_cases/categories_use_case.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_popular_workouts_use_case.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_muscles_by_group_id_use_case.dart';
import 'package:fitness_app/Features/workouts/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../../../profile/domain/entities/user_entity.dart';

@injectable
class GetHomeDataUseCase {
  final GetUserProfileUseCase _userUC;
  final GetCategoriesUseCase _categoriesUC;
  final GetPopularWorkoutsUseCase _workoutsUC;
  final GetRandomMusclesUseCase _randomUC;
  final GetMuscleGroupsUseCase _muscleGroupsUC;
  final GetMusclesByGroupIdUseCase _musclesByGroupUC;

  GetHomeDataUseCase(
    this._userUC,
    this._categoriesUC,
    this._workoutsUC,
    this._randomUC,
    this._muscleGroupsUC,
    this._musclesByGroupUC,
  );

  Stream<List<BaseResponse<HomeSection>>> execute() async* {
    final List<BaseResponse<HomeSection>?> results = List.filled(5, null);

    final controller = StreamController<List<BaseResponse<HomeSection>>>();

    void updateAndEmit(int index, BaseResponse<HomeSection> response) {
      results[index] = response;
      if (!controller.isClosed) {
        controller.add(List<BaseResponse<HomeSection>>.from(
            results.map((e) => e ?? ErrorResponse(errorMessage: "loading"))
        ));
      }
    }

    _userUC().then((res) {
      updateAndEmit(
        0,
        res is SuccessResponse<UserEntity>
            ? SuccessResponse(data: UserProfileSection(res.data))
            : ErrorResponse(errorMessage: (res as ErrorResponse).errorMessage),
      );
    });

    _randomUC().then((res) {
      updateAndEmit(
        1,
        res is SuccessResponse<List<RandomMusclesEntity>>
            ? SuccessResponse(data: RandomMuscleSection(res.data))
            : ErrorResponse(errorMessage: (res as ErrorResponse).errorMessage),
      );
    });

    _muscleGroupsUC().then((res) async {
      if (res is SuccessResponse<List<MuscleGroupEntity>>) {
        final firstId = res.data.first.id;
        final musclesRes = await _musclesByGroupUC(firstId);

        updateAndEmit(
          2,
          SuccessResponse(
            data: UpcomingWorkoutsSectionData(
              muscleGroups: res.data,
              currentGroupMuscles:
                  musclesRes is SuccessResponse<List<MuscleEntity>>
                  ? musclesRes.data
                  : [],
              selectedGroupId: firstId,
            ),
          ),
        );
      } else {
        updateAndEmit(2, ErrorResponse(errorMessage: "Failed to load muscles"));
      }
    });

    _categoriesUC().then((res) {
      updateAndEmit(
        3,
        res is SuccessResponse<List<CategoryEntity>>
            ? SuccessResponse(data: FoodCategoriesSection(res.data))
            : ErrorResponse(errorMessage: (res as ErrorResponse).errorMessage),
      );
    });

    _workoutsUC().first.then((res) {
      updateAndEmit(
        4,
        res is SuccessResponse<List<PopularWorkoutEntity>>
            ? SuccessResponse(data: PopularWorkoutsSection(res.data))
            : ErrorResponse(errorMessage: (res as ErrorResponse).errorMessage),
      );
    });

    yield* controller.stream;
  }
}
