import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

import 'login_state.dart';

class AppState {
  final LoginState loginState;
  final HomeState homeState;
  final UserActionState userActionState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;

  AppState({
    required this.loginState,
    required this.homeState,
    required this.userActionState,
    required this.chatStatusState,
    required this.chatState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final HomeState? homeState,
    final UserActionState? userActionState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      homeState: homeState ?? this.homeState,
      userActionState: userActionState ?? this.userActionState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      loginState: LoginState.notInitialized(),
      homeState: HomeState.notInitialized(),
      userActionState: UserActionState.notInitialized(),
      chatStatusState: ChatStatusState.notInitialized(),
      chatState: ChatState.notInitialized(),
    );
  }
}
