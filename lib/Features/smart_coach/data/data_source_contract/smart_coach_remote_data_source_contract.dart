import 'package:fitness_app/Features/smart_coach/data/models/responses/smart_coach_response.dart';

abstract class SmartCoachRemoteDataSourceContract {
  Future<SmartCoachResponse> getSmartCoachData();
}
