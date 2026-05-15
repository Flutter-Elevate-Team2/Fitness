import 'package:equatable/equatable.dart';

class MuscleGroupEntity extends Equatable {
  final String id;
  final String name;

  const MuscleGroupEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
