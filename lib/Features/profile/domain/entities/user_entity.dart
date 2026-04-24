class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String activityLevel;
  final String goal;
  final String photo;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photo,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goal,
  });

  UserEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? photo,
    String? gender,
    int? age,
    int? weight,
    int? height,
    String? activityLevel,
    String? goal,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}
