sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonClickedEvent({required this.email, required this.password});
}

class UserTypingEvent extends LoginEvent {}

class GoogleLoginEvent extends LoginEvent {
  final String email;

  GoogleLoginEvent({required this.email});

}