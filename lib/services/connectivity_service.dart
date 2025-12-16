import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  Stream<ConnectivityResult> get connectivityStream => _connectivity.onConnectivityChanged;

  Future<bool> isOnline() async {
    final res = await _connectivity.checkConnectivity();
    return res != ConnectivityResult.none;
  }

  void dispose() {
    // nothing to dispose for now
  }
}
