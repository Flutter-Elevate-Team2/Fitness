import 'package:fitness_app/Features/auth/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class SignUpStates {
  final BaseState<UserEntity>? signUpState;

  SignUpStates({this.signUpState});

  SignUpStates copyWith({
    BaseState<UserEntity>? signUpState,
  }) {
    return SignUpStates(
      signUpState: signUpState ?? this.signUpState,
    );
  }
}
