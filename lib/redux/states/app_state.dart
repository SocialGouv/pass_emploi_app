import 'login_state.dart';

class AppState {
  final LoginState loginState;

  AppState({required this.loginState});

  AppState copyWith({
    final LoginState? loginState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
    );
  }

  factory AppState.initialState() {
    return AppState(loginState: LoginState.notInitialized());
  }
}
