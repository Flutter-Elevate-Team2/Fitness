import 'package:fitness_app/Features/auth/data/data_sources/auth_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class HasValidTokenUseCase {
  final AuthLocalDataSourceContract _local;

  HasValidTokenUseCase(this._local);

  Future<bool> call() async {
    final token = await _local.getToken();
    return token != null && token.isNotEmpty;
  }
}
