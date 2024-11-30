import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityNotifier extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityNotifier() {
    _initConnectivity();
  }

  void _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile)) {
      _isConnected = true;
    }else{
      _isConnected = false;
    }

    // if (result.contains(ConnectivityResult.none)) {
    //   _isConnected = false;
    // } else {
    //   _isConnected = true;
    // }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
