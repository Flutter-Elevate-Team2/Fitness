import 'package:fitness_app/Features/smart_coach/data/data_source_contract/smart_coach_remote_data_source_contract.dart';
import 'package:fitness_app/Features/smart_coach/data/mapper/smart_coach_mapper.dart';
import 'package:fitness_app/Features/smart_coach/domain/entities/smart_coach_entity.dart';
import 'package:fitness_app/Features/smart_coach/domain/repo/smart_coach_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SmartCoachRepoContract)
class SmartCoachRepoImpl implements SmartCoachRepoContract {
  final SmartCoachRemoteDataSourceContract _remoteDataSource;

  SmartCoachRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<SmartCoachEntity>> getSmartCoachData() async {
    try {
      final response = await _remoteDataSource.getSmartCoachData();
      return SuccessResponse(data: response.toEntity());
    } catch (e) {
      return ErrorResponse(errorMessage: e.toString());
    }
  }
}
