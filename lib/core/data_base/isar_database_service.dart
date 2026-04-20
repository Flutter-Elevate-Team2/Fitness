import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


class IsarDatabaseService {
  IsarDatabaseService._();

  static IsarDatabaseService? _instance;

  static IsarDatabaseService get instance {
    assert(
      _instance != null,
      'IsarDatabaseService.init() must be called before accessing instance.',
    );
    return _instance!;
  }

  late final Isar _isar;

  Isar get db => _isar;


  static Future<void> init(List<CollectionSchema<dynamic>> schemas) async {
    if (_instance != null) return;

    final dir = await getApplicationDocumentsDirectory();

    final isar = await Isar.open(
      schemas,
      directory: dir.path,
      name: 'fitness_app_db',
    );

    _instance = IsarDatabaseService._().._isar = isar;
  }

  Future<void> close() async {
    await _isar.close();
    _instance = null;
  }
}
