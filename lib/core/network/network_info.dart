import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

// coverage:ignore-file

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    return !results.contains(ConnectivityResult.none);
  }
}
