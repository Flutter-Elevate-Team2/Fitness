import 'package:fitness_app/Features/home/data/models/levels_respones/levels_respones.dart';

abstract class HomeRemoteDataSourceContract {
  Future<LevelsRespones> getLevels();

}
