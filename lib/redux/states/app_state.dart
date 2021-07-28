import 'package:pass_emploi_app/redux/states/home_state.dart';

import 'login_state.dart';

class AppState {
  final LoginState loginState;
  final HomeState homeState;

  AppState({required this.loginState, required this.homeState});

  AppState copyWith({
    final LoginState? loginState,
    final HomeState? homeState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      homeState: homeState ?? this.homeState,
    );
  }

  factory AppState.initialState() {
    return AppState(loginState: LoginState.notInitialized(), homeState: HomeState.notInitialized());
  }
}
