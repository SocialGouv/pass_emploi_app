import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_create_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

import 'login_state.dart';

class AppState {
  final LoginState loginState;
  final HomeState homeState;
  final UserActionState userActionState;
  final UserActionCreateState createUserActionState;
  final UserActionUpdateState userActionUpdateState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;

  AppState({
    required this.loginState,
    required this.homeState,
    required this.userActionState,
    required this.createUserActionState,
    required this.userActionUpdateState,
    required this.chatStatusState,
    required this.chatState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final HomeState? homeState,
    final UserActionState? userActionState,
    final UserActionCreateState? createUserActionState,
    final UserActionUpdateState? userActionUpdateState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      homeState: homeState ?? this.homeState,
      userActionState: userActionState ?? this.userActionState,
      createUserActionState: createUserActionState ?? this.createUserActionState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      loginState: LoginState.notInitialized(),
      homeState: HomeState.notInitialized(),
      userActionState: UserActionState.notInitialized(),
      createUserActionState: UserActionCreateState.notInitialized(),
      userActionUpdateState: UserActionUpdateState.notUpdating(),
      chatStatusState: ChatStatusState.notInitialized(),
      chatState: ChatState.notInitialized(),
    );
  }

  @override
  String toString() {
    return 'AppState{'
        'loginState: $loginState, '
        'homeState: $homeState, '
        'userActionState: $userActionState, '
        'createUserActionState: $createUserActionState, '
        'userActionUpdateState: $userActionUpdateState, '
        'chatStatusState: $chatStatusState, '
        'chatState: $chatState'
        '}';
  }
}
