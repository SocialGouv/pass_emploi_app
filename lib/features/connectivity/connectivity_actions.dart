import 'package:connectivity_plus/connectivity_plus.dart';

class SubscribeToConnectivityUpdatesAction {}

class UnsubscribeFromConnectivityUpdatesAction {}

class ConnectivityUpdatedAction {
  final ConnectivityResult result;

  ConnectivityUpdatedAction(this.result);
}
