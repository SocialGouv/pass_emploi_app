import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

class ConnectivityState extends Equatable {
  final ConnectivityResult result;

  @override
  List<Object?> get props => [result];

  ConnectivityState._(this.result);

  factory ConnectivityState.notInitialized() => ConnectivityState._(ConnectivityResult.none);

  factory ConnectivityState.fromResult(ConnectivityResult result) => ConnectivityState._(result);

  bool isOnline() => result != ConnectivityResult.none;

  bool isOffline() => !isOnline();
}
