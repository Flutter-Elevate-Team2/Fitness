import 'package:fitness_app/Features/smart_coach/domain/entities/smart_coach_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

abstract class SmartCoachRepoContract {
  Future<BaseResponse<SmartCoachEntity>> getSmartCoachData();
}
