import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
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
}

class MainPageViewModel extends Equatable {
  final bool withChatBadge;
  final bool showRating;
  final Function resetDeeplink;

  MainPageViewModel({
    required this.withChatBadge,
    required this.showRating,
    required this.resetDeeplink,
  });

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    final ratingState = store.state.ratingState;

    return MainPageViewModel(
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
      showRating: ratingState is ShowRatingState,
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [withChatBadge, showRating];
}
