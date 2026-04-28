import 'package:fitness_app/Features/smart_coach/domain/entities/smart_coach_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/use_cases/get_smart_coach_data_use_case.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SmartCoachViewModel extends Cubit<SmartCoachState> {
  final GetSmartCoachDataUseCase _getSmartCoachDataUseCase;

  SmartCoachViewModel(this._getSmartCoachDataUseCase) : super(SmartCoachState());

  void getSmartCoachData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getSmartCoachDataUseCase.call();

    if (result is SuccessResponse<SmartCoachEntity>) {
      emit(state.copyWith(isLoading: false, data: (result as SuccessResponse<SmartCoachEntity>).data));
    } else if (result is ErrorResponse<SmartCoachEntity>) {
      emit(state.copyWith(isLoading: false, errorMessage: (result as ErrorResponse<SmartCoachEntity>).errorMessage));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: "Unknown error occurred"));
    }
  }
}
