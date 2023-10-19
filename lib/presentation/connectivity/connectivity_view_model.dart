import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ConnectivityViewModel extends Equatable {
  final bool isConnected;

  ConnectivityViewModel._(this.isConnected);

  factory ConnectivityViewModel.create(Store<AppState> store) {
    final connectivityResult = store.state.connectivityState.result;
    return ConnectivityViewModel._(connectivityResult != ConnectivityResult.none);
  }

  @override
  List<Object?> get props => [isConnected];
}
