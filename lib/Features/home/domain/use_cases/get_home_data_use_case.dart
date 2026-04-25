import 'package:fitness_app/Features/food/domain/entities/category_entity.dart';
import 'package:fitness_app/Features/home/domain/factory/home_factory.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/Features/workouts/domain/entities/random_muscles_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../../profile/domain/entities/user_entity.dart';

@injectable
class GetHomeDataUseCase {
  final HomeFactory _factory;
  GetHomeDataUseCase(this._factory);

  Stream<HomeState> call() async* {
    HomeState state = HomeState(isLoading: true);
    yield state;

    try {
      await for (final res in _factory.getUserData()) {
        if (res is SuccessResponse<UserEntity>) {
          state = state.copyWith(user: res.data);
          yield state;
        }
      }

      final groupsRes = await _factory.getMuscleGroups();

      if (groupsRes is SuccessResponse<List<MuscleGroupEntity>>) {
        final groupsData = groupsRes.data;

        if (groupsData.isNotEmpty) {
          final firstId = groupsData[0].id;
          final musclesRes = await _factory.getMusclesByGroupId(firstId);

          if (musclesRes is SuccessResponse<List<MuscleEntity>>) {
            state = state.copyWith(
              muscleGroups: groupsData,
              currentGroupMuscles: musclesRes.data,
              selectedGroupId: firstId,
            );
            yield state;
          }
        }
      }

      // Random Muscles (Stream)
      await for (final res in _factory.getRandomMuscles()) {
        if (res is SuccessResponse<List<RandomMusclesEntity>>) {
          state = state.copyWith(randomMuscles: res.data);
          yield state;
        }
      }

      // Food Categories (Stream)
      await for (final res in _factory.getFoodCategories()) {
        if (res is SuccessResponse<List<CategoryEntity>>) {
          state = state.copyWith(foodCategories: res.data);
          yield state;
        }
      }
      state = state.copyWith(isLoading: false);
      yield state;

    } catch (e) {
      yield state.copyWith(isLoading: false);
    }
  }
}
