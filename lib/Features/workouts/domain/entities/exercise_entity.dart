import 'package:equatable/equatable.dart';
class ExerciseEntity extends Equatable {
  final String id;
  final String title;         
  final String description;   
  final int sets;            
  final int reps;             
  final String thumbnailUrl;  
  final String? videoUrl;     

  const ExerciseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.sets,
    required this.reps,
    required this.thumbnailUrl,
    this.videoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        sets,
        reps,
        thumbnailUrl,
        videoUrl,
      ];
}