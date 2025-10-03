import 'package:flutter/material.dart';
import 'package:messaging_app/core/services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _service = ConnectivityService();
  bool _hasConnection = true;

  bool get hasConnection => _hasConnection;

  ConnectivityProvider() {
    _init();
  }

  void _init() async {
    _hasConnection = await _service.hasConnection();
    notifyListeners();

    _service.connectivityStream.listen((results) {
      if (results.isNotEmpty) {
        final result = results.first;
        _hasConnection = result != ConnectivityResult.none;
        notifyListeners();
      }
    });
  }
}
