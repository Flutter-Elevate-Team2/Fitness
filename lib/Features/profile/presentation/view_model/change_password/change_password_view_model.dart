import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/chang_password_use_case.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/controller/session_controller.dart'; 

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordStates> {
  final ChangPasswordUseCase changPasswordUseCase;
  final SessionController _sessionController;

  ChangePasswordViewModel(this.changPasswordUseCase, this._sessionController)
      : super(const ChangePasswordStates());

  void doIntent(ChangePasswordEvents event) {
    switch (event) {
      case ChangePasswordEvent():
        _changePassword(event.request);
        break;
    }
  }

  Future<void> _changePassword(ChangePasswordRequest request) async {
    emit(state.copyWith(changePasswordState:  BaseState(isLoading: true)));
    
    final result = await changPasswordUseCase(request);
    
    switch (result) {
      case SuccessResponse<ChangePasswordEntity>():
        if (result.data.token.isNotEmpty) {
           await _sessionController.updateSessionAuth(result.data.token);
        }

        emit(
          state.copyWith(
            changePasswordState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;

      case ErrorResponse<ChangePasswordEntity>():
        emit(
          state.copyWith(
            changePasswordState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}