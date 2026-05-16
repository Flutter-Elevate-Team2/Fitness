import 'package:fitness_app/Features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/social_login_auth/auth_services.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_events.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_states.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpViewModel extends Cubit<SignUpStates> {
  final RegisterUseCase _registerUseCase;

  SignUpViewModel(this._registerUseCase) : super(SignUpStates());

  void doIntent(SignUpEvent event) {
    switch (event) {
      case OnSignUpClickEvent():
        _handleSignUp(event);
        break;
    }
  }

  void _handleSignUp(OnSignUpClickEvent event) async {
    emit(state.copyWith(
      signUpState: const BaseState<UserEntity>(isLoading: true),
    ));

    final response = await _registerUseCase.register(
      RegisterParams(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        rePassword: event.rePassword,
        gender: event.gender,
        age: event.age,
        weight: event.weight,
        height: event.height,
        goal: event.goal,
        activityLevel: event.activityLevel,
      ),
    );

    switch (response) {
      case SuccessResponse<UserEntity>():
        AuthServices.signInWithGoogle();

        emit(
          state.copyWith(
            signUpState: BaseState<UserEntity>(
              isLoading: false,
              data: response.data,
              errorMessage: null,
            ),
          ),
        );
        break;

      case ErrorResponse<UserEntity>():
        emit(
          state.copyWith(
            signUpState: BaseState<UserEntity>(
              isLoading: false,
              data: null,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
