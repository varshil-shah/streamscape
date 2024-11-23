import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _isConnected = result.any(
        (connectivity) => connectivity != ConnectivityResult.none,
      );
      notifyListeners();
    });
  }

  bool get isConnected => _isConnected;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
