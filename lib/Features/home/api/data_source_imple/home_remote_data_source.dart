import 'package:fitness_app/Features/home/data/data_source_contract/home_remot_data_source.dart';
import 'package:fitness_app/Features/home/api/api_client/home_api.dart';
import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRemoteDataSourceContract)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceContract {
  final HomeApi homeApi;
  HomeRemoteDataSourceImpl({required this.homeApi});

  @override
  Future<LevelsRespones> getLevels() {
    return homeApi.getLevels();
  }
}
