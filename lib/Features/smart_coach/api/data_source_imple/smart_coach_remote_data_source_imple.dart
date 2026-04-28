import 'package:fitness_app/Features/smart_coach/api/api_client/smart_coach_api.dart';
import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_remote_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/models/responses/smart_coach_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SmartCoachRemoteDataSourceContract)
class SmartCoachRemoteDataSourceImple implements SmartCoachRemoteDataSourceContract {
  final SmartCoachApi _api;

  SmartCoachRemoteDataSourceImple(this._api);

  @override
  Future<SmartCoachResponse> getSmartCoachData() async {
    return await _api.getSmartCoachData();
  }
}
