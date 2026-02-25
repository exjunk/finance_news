// lib/core/utils/connectivity_checker.dart
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Stream<bool> get connectivityStream =>
      _connectivity.onConnectivityChanged
          .map((result) => result != ConnectivityResult.none);
}
