import 'package:fitness_app/Features/profile/data/mapper/user_profile_mapper.dart';
import 'package:fitness_app/Features/profile/data/models/user_profile_response.dart';
import 'package:fitness_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/helpers/api_execution_mixin.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImple with ApiExecutionMixin implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;
  ProfileRepoImple(this._remoteDataSource);


  @override
  Future<BaseResponse<UserEntity>> getUserProfile() async {
    return execute<UserProfileResponse, UserEntity>(
      action: () async => await _remoteDataSource.getUserProfile(),
      mapper: (response) => response.toEntity(),
    );
  }

}
