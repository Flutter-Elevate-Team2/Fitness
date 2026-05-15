import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class LoginState extends Equatable {
  final BaseState<LoginEntity>? loginState;

  const LoginState({this.loginState});

  LoginState copyWith({BaseState<LoginEntity>? loginState}) {
    return LoginState(loginState: loginState ?? this.loginState);
  }

  @override
  List<Object?> get props => [loginState];
}
