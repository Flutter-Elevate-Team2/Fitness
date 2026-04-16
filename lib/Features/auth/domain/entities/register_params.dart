import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String activityLevel;
  final String goal;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goal,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        gender,
        age,
        weight,
        height,
        activityLevel,
        goal,
      ];
}
