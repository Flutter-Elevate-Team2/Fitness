import 'package:fitness_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final SessionController _sessionController;

  LoginViewModel(this._loginUseCase, this._sessionController)
      : super(const LoginState());

  Future<void> doIntent(LoginEvent event)async {
    switch (event) {
      case LoginInitialEvent():
        _onInit();
        break;
      case UserTypingEvent():
        _resetErrorState();
        break;
      case LoginButtonClickedEvent():
        await _handleLogin(event: event);
        break;
      case GoogleLoginEvent():
       await _handleLogin(email : event.email);

    }
  }

  void _onInit() {
    emit(const LoginState());
  }

  void _resetErrorState() {
    if (state.loginState?.errorMessage != null ||
        state.loginState?.isLoading == true) {
      emit(state.copyWith(loginState: const BaseState()));
    }
  }

  Future<void> _handleLogin( {LoginButtonClickedEvent? event , String? email}) async {

    emit(state.copyWith(loginState: const BaseState(isLoading: true)));

    final response = await _loginUseCase.call(
      LoginRequest(email: event?.email ?? email , password: event?.password ?? ApiConstants.defaultPassword),
    );

    switch (response) {
      case SuccessResponse<LoginEntity>():
         _sessionController.notifyLogin();

        emit(
          state.copyWith(
            loginState: BaseState(isLoading: false, data: response.data),
          ),
        );
        break;

      case ErrorResponse<LoginEntity>():
        emit(
          state.copyWith(
            loginState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
