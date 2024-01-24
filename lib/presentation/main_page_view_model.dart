import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum MainTab { accueil, monSuivi, chat, solutions, evenements }

enum MainPageDisplayState {
  accueil,
  monSuivi,
  chat,
  evenements,
  solutionsRecherche,
  solutionsOutils,
  actualisationPoleEmploi,
}

class MainPageViewModel extends Equatable {
  final List<MainTab> tabs;
  final bool withChatBadge;
  final bool showRating;
  final LoginMode? loginMode;
  final Function resetDeeplink;
  final String actualisationPoleEmploiUrl;

  MainPageViewModel({
    required this.tabs,
    required this.withChatBadge,
    required this.showRating,
    required this.loginMode,
    required this.resetDeeplink,
    required this.actualisationPoleEmploiUrl,
  });

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    final ratingState = store.state.ratingState;
    final loginState = store.state.loginState;
    return MainPageViewModel(
      tabs: [
        MainTab.accueil,
        MainTab.monSuivi,
        MainTab.chat,
        MainTab.solutions,
        MainTab.evenements,
      ],
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
      showRating: ratingState is ShowRatingState,
      loginMode: loginState is LoginSuccessState ? loginState.user.loginMode : null,
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      actualisationPoleEmploiUrl: store.state.configurationState.configuration?.actualisationPoleEmploiUrl ?? "",
    );
  }

  @override
  List<Object?> get props => [tabs, withChatBadge, showRating, loginMode];
}
