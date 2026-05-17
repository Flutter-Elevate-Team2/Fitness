import 'package:fitness_app/Features/home/data/data_source_contract/home_remot_data_source.dart';
import 'package:fitness_app/Features/home/data/mapper/mappers.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:fitness_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:fitness_app/Features/workouts/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/helpers/api_execution_mixin.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepoContract)
class HomeRepoImpl with ApiExecutionMixin  implements  HomeRepoContract {
  final HomeRemoteDataSourceContract _homeRemoteDataSource;
  HomeRepoImpl(this._homeRemoteDataSource);
  @override
  Future<BaseResponse<List<DifficultyLevelEntity>>> getLevels() {
   return execute<LevelsRespones,List<DifficultyLevelEntity>>(
    action: () => _homeRemoteDataSource.getLevels(),
    mapper: (data) => data.toEntity(),
   );
  }
}
