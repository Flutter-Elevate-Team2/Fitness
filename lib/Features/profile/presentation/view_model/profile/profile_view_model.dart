import 'package:fitness_app/Features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/logout_use_case.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_states.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileStates> {
  ProfileViewModel(
    this._getUserProfileUseCase,
    this._sessionController,
    this._logoutUseCase,
      ) : super(const ProfileStates()) {
    _sessionController.onLogin.listen((_) {
      _getProfile();
    });
  }

  final GetUserProfileUseCase _getUserProfileUseCase;
  final SessionController _sessionController;
  final LogoutUseCase _logoutUseCase;

  void doIntent(ProfileEvents event) {
    switch (event) {
      case GetUserProfileEvent():
        _getProfile();
        break;
      case LogoutEvent():
        _logout();
        break;
    }
  }


  Future<void> _getProfile() async {
    emit(state.copyWith(profileState: BaseState(isLoading: true)));

    final result = await _getUserProfileUseCase.call();

    switch (result) {
      case SuccessResponse():

        emit(
          state.copyWith(
            profileState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;

      case ErrorResponse( ):
        emit(
          state.copyWith(
            profileState: BaseState(
              isLoading: false,
              errorMessage: (result as ErrorResponse).errorMessage,
            ),
          ),
        );
        break;
    }
  }
  Future<void> _logout() async {
    if (isClosed) return;
    emit(state.copyWith(logoutState: BaseState(isLoading: true)));

    final result = await _logoutUseCase.call();

    if (isClosed) return;

    switch (result) {
      case SuccessResponse():
        await _sessionController.notifyLogout(SessionEndReason.logout);

        emit(
          state.copyWith(logoutState: BaseState(isLoading: false, data: null)),
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            logoutState: BaseState(
              isLoading: false,
              errorMessage: (result as ErrorResponse).errorMessage,
            ),
          ),
        );
        break;
    }
  }

 }
