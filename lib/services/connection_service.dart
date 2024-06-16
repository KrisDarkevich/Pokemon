import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool hasInternet = connectivityResult != ConnectivityResult.none;
    return await hasInternet;
  }
}
