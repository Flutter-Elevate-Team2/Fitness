import 'package:fitness_app/Features/home/domain/entities/popular_tranning_entity.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/home/domain/factory/home_factory.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final HomeFactory _factory;

  HomeViewModel(this._factory) : super(HomeState());

  void initHome() {
    emit(state.copyWith(
      isLoading: true,
      popularWorkoutsState: const BaseState(isLoading: true),
    ));

    _factory.getUserData().listen((res) {
      if (res is SuccessResponse<UserEntity>) {
        emit(state.copyWith(user: res.data));
      }
    });

    _factory.getFoodCategories().listen((res) {
      if (res is SuccessResponse<List<CategoryEntity>>) {
        emit(state.copyWith(foodCategories: res.data));
      }
    });

    _factory.getRandomMuscles().listen((res) {
      if (res is SuccessResponse<List<RandomMusclesEntity>>) {
        emit(state.copyWith(randomMuscles: res.data));
      }
    });

    _factory.getMuscleGroups().then((groupsRes) {
      if (groupsRes is SuccessResponse<List<MuscleGroupEntity>>) {
        final groupsData = groupsRes.data;

        if (groupsData.isNotEmpty) {
          final firstId = groupsData[0].id;

          _factory.getMusclesByGroupId(firstId).then((musclesRes) {
            if (musclesRes is SuccessResponse<List<MuscleEntity>>) {
              emit(state.copyWith(
                muscleGroups: groupsData,
                currentGroupMuscles: musclesRes.data,
                selectedGroupId: firstId,
                isLoading: false,
              ));
            } else {
              emit(state.copyWith(isLoading: false));
            }
          });
        } else {
          emit(state.copyWith(isLoading: false));
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }).catchError((_) {
      emit(state.copyWith(isLoading: false));
    });

    _factory.getPopularWorkouts().listen(
      (res) {
        if (res is SuccessResponse<List<PopularWorkoutEntity>>) {
          emit(state.copyWith(
            popularWorkoutsState: BaseState(
              data: res.data,
              isLoading: true,
            ),
          ));
        } else if (res is ErrorResponse) {
          emit(state.copyWith(
            popularWorkoutsState: BaseState(
              errorMessage: (res as ErrorResponse).errorMessage,
            ),
          ));
        }
      },
      onDone: () {
        emit(state.copyWith(
          popularWorkoutsState: state.popularWorkoutsState.copyWith(
            isLoading: false,
          ),
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          popularWorkoutsState: BaseState(errorMessage: error.toString()),
        ));
      },
    );
  }

  void changeMuscleGroup(String id) async {
    emit(state.copyWith(selectedGroupId: id, currentGroupMuscles: []));
    final res = await _factory.getMusclesByGroupId(id);

    if (res is SuccessResponse<List<MuscleEntity>>) {
      emit(state.copyWith(currentGroupMuscles: res.data));
    } else {
      emit(state.copyWith(currentGroupMuscles: []));
    }
  }
}
