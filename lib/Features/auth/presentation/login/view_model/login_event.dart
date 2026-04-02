sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class ToggleRememberMeEvent extends LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonClickedEvent({required this.email, required this.password});
}

class UserTypingEvent extends LoginEvent {}
