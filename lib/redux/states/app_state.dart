import 'login_state.dart';

class AppState {
  final LoginState loginState;

  AppState({required this.loginState});

  factory AppState.initialState() {
    return AppState(loginState: LoginState.notInitialized());
  }
}
