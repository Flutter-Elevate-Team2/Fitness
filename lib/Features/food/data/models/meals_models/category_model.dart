import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@HiveType(typeId: 9)
@JsonSerializable()
class CategoryModel extends Equatable {
  @HiveField(0)
  @JsonKey(name: "idCategory")
  final String? idCategory;

  @HiveField(1)
  @JsonKey(name: "strCategory")
  final String? strCategory;

  @HiveField(2)
  @JsonKey(name: "strCategoryThumb")
  final String? strCategoryThumb;

  @HiveField(3)
  @JsonKey(name: "strCategoryDescription")
  final String? strCategoryDescription;

  const CategoryModel({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  List<Object?> get props => [
    idCategory,
    strCategory,
    strCategoryThumb,
    strCategoryDescription,
  ];
}
