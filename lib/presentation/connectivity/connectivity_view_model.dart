import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ConnectivityViewModel extends Equatable {
  final bool isOnline;

  ConnectivityViewModel._(this.isOnline);

  factory ConnectivityViewModel.create(Store<AppState> store) {
    return ConnectivityViewModel._(store.state.connectivityState.isOnline() || store.state.demoState);
  }

  @override
  List<Object?> get props => [isOnline];
}
