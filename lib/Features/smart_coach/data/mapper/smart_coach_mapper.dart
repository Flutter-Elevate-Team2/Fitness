import 'package:fitness_app/Features/smart_coach/data/models/responses/smart_coach_response.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/smart_coach_entity.dart';

extension SmartCoachMapper on SmartCoachResponse {
  SmartCoachEntity toEntity() {
    return SmartCoachEntity(
      id: id ?? '',
      message: message ?? '',
    );
  }
}
