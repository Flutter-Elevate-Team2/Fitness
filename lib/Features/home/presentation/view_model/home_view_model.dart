import 'package:fitness_app/Features/home/domain/factory/home_factory.dart';
import 'package:fitness_app/Features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/workouts/domain/entities/muscle_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final HomeFactory _factory;

  HomeViewModel(this._getHomeDataUseCase, this._factory) : super(HomeState());

  void initHome() {
    _getHomeDataUseCase.call().listen((updatedState) {
      emit(updatedState);
    });
  }

  void changeMuscleGroup(String id) async {
    emit(state.copyWith(selectedGroupId: id));

    final res = await _factory.getMusclesByGroupId(id);

    if (res is SuccessResponse<List<MuscleEntity>>) {
      emit(state.copyWith(currentGroupMuscles: res.data));
    } else {
      emit(state.copyWith(currentGroupMuscles: []));
    }
  }
}
