sealed class SignUpEvent {}

class OnSignUpClickEvent extends SignUpEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String goal;
  final String activityLevel;

  OnSignUpClickEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    required this.activityLevel,
  });
}
