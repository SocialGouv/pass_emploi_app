import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum MainPageDisplayState { DEFAULT, ACTIONS_TAB, RENDEZVOUS_TAB, CHAT, SEARCH, SAVED_SEARCH }

class MainPageViewModel extends Equatable {
  final bool withChatBadge;
  final bool isPoleEmploiLogin;
  final bool share;

  MainPageViewModel({required this.withChatBadge, required this.isPoleEmploiLogin, required this.share});

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    final loginState = store.state.loginState;
    final loginMode = loginState is LoginSuccessState ? loginState.user.loginMode : null;
    final shareFile = store.state.shareFileState;

    return MainPageViewModel(
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
      isPoleEmploiLogin: loginMode.isPe(),
      share: shareFile is ShareFileSuccessState,
    );
  }

  @override
  List<Object?> get props => [withChatBadge, isPoleEmploiLogin, share];
}
