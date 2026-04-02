import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class LoginState extends Equatable {
  final BaseState<LoginEntity>? loginState;
  final bool isRememberMe;

  const LoginState({this.loginState, this.isRememberMe = false});

  LoginState copyWith({
    BaseState<LoginEntity>? loginState,
    bool? isRememberMe,
    String? activeOrderId,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      isRememberMe: isRememberMe ?? this.isRememberMe,
    );
  }

  @override
  List<Object?> get props => [loginState, isRememberMe];
}
