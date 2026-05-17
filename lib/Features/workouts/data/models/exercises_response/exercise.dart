import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  @JsonKey(name: '_id')
  String? id;
  String? exercise;
  @JsonKey(name: 'short_youtube_demonstration')
  String? shortYoutubeDemonstration;
  @JsonKey(name: 'in_depth_youtube_explanation')
  String? inDepthYoutubeExplanation;
  @JsonKey(name: 'difficulty_level')
  String? difficultyLevel;
  @JsonKey(name: 'target_muscle_group')
  String? targetMuscleGroup;
  @JsonKey(name: 'prime_mover_muscle')
  String? primeMoverMuscle;
  @JsonKey(name: 'secondary_muscle')
  String? secondaryMuscle;
  @JsonKey(name: 'tertiary_muscle')
  String? tertiaryMuscle;
  @JsonKey(name: 'primary_equipment')
  String? primaryEquipment;
  @JsonKey(name: '_primary_items')
  num? primaryItems;
  @JsonKey(name: 'secondary_equipment')
  dynamic secondaryEquipment;
  @JsonKey(name: '_secondary_items')
  num? secondaryItems;
  String? posture;
  @JsonKey(name: 'single_or_double_arm')
  String? singleOrDoubleArm;
  @JsonKey(name: 'continuous_or_alternating_arms')
  String? continuousOrAlternatingArms;
  String? grip;
  @JsonKey(name: 'load_position_ending')
  String? loadPositionEnding;
  @JsonKey(name: 'continuous_or_alternating_legs')
  String? continuousOrAlternatingLegs;
  @JsonKey(name: 'foot_elevation')
  String? footElevation;
  @JsonKey(name: 'combination_exercises')
  String? combinationExercises;
  @JsonKey(name: 'movement_pattern_1')
  String? movementPattern1;
  @JsonKey(name: 'movement_pattern_2')
  dynamic movementPattern2;
  @JsonKey(name: 'movement_pattern_3')
  dynamic movementPattern3;
  @JsonKey(name: 'plane_of_motion_1')
  String? planeOfMotion1;
  @JsonKey(name: 'plane_of_motion_2')
  dynamic planeOfMotion2;
  @JsonKey(name: 'plane_of_motion_3')
  dynamic planeOfMotion3;
  @JsonKey(name: 'body_region')
  String? bodyRegion;
  @JsonKey(name: 'force_type')
  String? forceType;
  String? mechanics;
  String? laterality;
  @JsonKey(name: 'primary_exercise_classification')
  String? primaryExerciseClassification;
  @JsonKey(name: 'short_youtube_demonstration_link')
  String? shortYoutubeDemonstrationLink;
  @JsonKey(name: 'in_depth_youtube_explanation_link')
 String? inDepthYoutubeExplanationLink;

  Exercise({
    this.id,
    this.exercise,
    this.shortYoutubeDemonstration,
    this.inDepthYoutubeExplanation,
    this.difficultyLevel,
    this.targetMuscleGroup,
    this.primeMoverMuscle,
    this.secondaryMuscle,
    this.tertiaryMuscle,
    this.primaryEquipment,
    this.primaryItems,
    this.secondaryEquipment,
    this.secondaryItems,
    this.posture,
    this.singleOrDoubleArm,
    this.continuousOrAlternatingArms,
    this.grip,
    this.loadPositionEnding,
    this.continuousOrAlternatingLegs,
    this.footElevation,
    this.combinationExercises,
    this.movementPattern1,
    this.movementPattern2,
    this.movementPattern3,
    this.planeOfMotion1,
    this.planeOfMotion2,
    this.planeOfMotion3,
    this.bodyRegion,
    this.forceType,
    this.mechanics,
    this.laterality,
    this.primaryExerciseClassification,
    this.shortYoutubeDemonstrationLink,
    this.inDepthYoutubeExplanationLink,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return _$ExerciseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
