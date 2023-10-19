import 'package:connectivity_plus/connectivity_plus.dart';

class SubscribeToConnectivityUpdates {}

class UnsubscribeFromConnectivityUpdates {}

class ConnectivityUpdatedAction {
  final ConnectivityResult result;

  ConnectivityUpdatedAction(this.result);
}
