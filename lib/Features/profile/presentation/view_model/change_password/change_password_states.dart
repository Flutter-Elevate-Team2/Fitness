import 'package:fitness_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class ChangePasswordStates {
  final BaseState<ChangePasswordEntity>? changePasswordState;

const  ChangePasswordStates({this.changePasswordState});
  ChangePasswordStates copyWith({
    BaseState<ChangePasswordEntity>? changePasswordState,
  }) {
    return ChangePasswordStates(
     changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }
}