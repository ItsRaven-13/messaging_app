import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkUtils {
  static Future<bool> hasInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    final bool isConnected = await InternetConnection().hasInternetAccess;
    return isConnected;
  }
}
