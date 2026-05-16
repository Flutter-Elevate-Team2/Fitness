import 'package:json_annotation/json_annotation.dart';

part 'random_muscles.g.dart';

@JsonSerializable()
class RandomMuscles {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "totalMuscles")
  final int? totalMuscles;
  @JsonKey(name: "muscles")
  final List<Muscles>? muscles;

  RandomMuscles ({
    this.message,
    this.totalMuscles,
    this.muscles,
  });

  factory RandomMuscles.fromJson(Map<String, dynamic> json) {
    return _$RandomMusclesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RandomMusclesToJson(this);
  }
}

@JsonSerializable()
class Muscles {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "image")
  final String? image;

  Muscles ({
    this.id,
    this.name,
    this.image,
  });

  factory Muscles.fromJson(Map<String, dynamic> json) {
    return _$MusclesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MusclesToJson(this);
  }
}


