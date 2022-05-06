import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum MainPageDisplayState { DEFAULT, ACTIONS_TAB, RENDEZVOUS_TAB, CHAT, SEARCH, SAVED_SEARCH }

class MainPageViewModel extends Equatable {
  final bool withChatBadge;
  final bool isPoleEmploiLogin;

  MainPageViewModel({required this.withChatBadge, required this.isPoleEmploiLogin});

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    final loginState = store.state.loginState;
    final loginMode = loginState is LoginSuccessState ? loginState.user.loginMode : null;

    return MainPageViewModel(
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
      isPoleEmploiLogin: loginMode == LoginMode.POLE_EMPLOI || loginMode == LoginMode.DEMO_PE,
    );
  }

  @override
  List<Object?> get props => [withChatBadge];
}
