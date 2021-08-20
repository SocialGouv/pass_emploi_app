import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

import 'login_state.dart';

class AppState {
  final LoginState loginState;
  final UserActionState userActionState;
  final ChatState chatState;

  AppState({required this.loginState, required this.userActionState, required this.chatState});

  AppState copyWith({
    final LoginState? loginState,
    final UserActionState? userActionState,
    final ChatState? chatState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      userActionState: userActionState ?? this.userActionState,
      chatState: chatState ?? this.chatState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      loginState: LoginState.notInitialized(),
      userActionState: UserActionState.notInitialized(),
      chatState: ChatState.notInitialized(),
    );
  }
}
