import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum MainPageDisplayState {
  DEFAULT,
  ACTIONS_TAB,
  RENDEZVOUS_TAB,
  CHAT,
  SEARCH,
  SAVED_SEARCH,
  EVENT_LIST,
  ACTUALISATION_PE,
  EVENEMENTS,
}

class MainPageViewModel extends Equatable {
  final bool withChatBadge;
  final bool showRating;
  final bool withEvenements;
  final Function resetDeeplink;
  final String actualisationPoleEmploiUrl;

  MainPageViewModel({
    required this.withChatBadge,
    required this.showRating,
    required this.withEvenements,
    required this.resetDeeplink,
    required this.actualisationPoleEmploiUrl,
  });

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    final ratingState = store.state.ratingState;
    final loginState = store.state.loginState;
    final loginMode = loginState is LoginSuccessState ? loginState.user.loginMode : null;
    final bool withEvenements = loginMode.isMiLo();
    return MainPageViewModel(
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
      showRating: ratingState is ShowRatingState,
      withEvenements: withEvenements,
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      actualisationPoleEmploiUrl: store.state.configurationState.configuration?.actualisationPoleEmploiUrl ?? "",
    );
  }

  @override
  List<Object?> get props => [withChatBadge, showRating];
}
