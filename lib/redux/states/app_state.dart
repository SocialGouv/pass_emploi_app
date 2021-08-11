import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';

import 'login_state.dart';

class AppState {
  final LoginState loginState;
  final HomeState homeState;
  final ChatState chatState;

  AppState({required this.loginState, required this.homeState, required this.chatState});

  AppState copyWith({
    final LoginState? loginState,
    final HomeState? homeState,
    final ChatState? chatState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      homeState: homeState ?? this.homeState,
      chatState: chatState ?? this.chatState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      loginState: LoginState.notInitialized(),
      homeState: HomeState.notInitialized(),
      chatState: ChatState.notInitialized(),
    );
  }
}
