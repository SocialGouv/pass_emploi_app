import 'package:connectivity_plus/connectivity_plus.dart';

class SubscribeToConnectivityUpdatesAction {}

class UnsubscribeFromConnectivityUpdatesAction {}

class ConnectivityUpdatedAction {
  final List<ConnectivityResult> results;

  ConnectivityUpdatedAction(this.results);
}
