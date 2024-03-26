import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

class ConnectivityState extends Equatable {
  final List<ConnectivityResult> results;

  @override
  List<Object?> get props => [results];

  ConnectivityState._(this.results);

  factory ConnectivityState.notInitialized() => ConnectivityState._([]);

  factory ConnectivityState.fromResults(List<ConnectivityResult> results) => ConnectivityState._(results);

  bool isOnline() => results.isOnline();

  bool isOffline() => !results.isOnline();
}

extension ConnectivityResultExtension on List<ConnectivityResult> {
  bool isOnline() => !contains(ConnectivityResult.none);
}
