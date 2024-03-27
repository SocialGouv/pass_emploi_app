import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWrapper {
  final Stream<List<ConnectivityResult>> onConnectivityChanged;
  StreamSubscription<List<ConnectivityResult>>? subscription;

  ConnectivityWrapper(this.onConnectivityChanged);

  factory ConnectivityWrapper.fromConnectivity() => ConnectivityWrapper(Connectivity().onConnectivityChanged);

  void subscribeToUpdates(void Function(List<ConnectivityResult> results) onUpdate) {
    if (subscription != null) return;
    subscription = onConnectivityChanged.listen(onUpdate);
  }

  void unsubscribeFromUpdates() {
    subscription?.cancel();
    subscription = null;
  }
}
