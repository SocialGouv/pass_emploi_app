import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum MainPageDisplayState { DEFAULT, ACTIONS_TAB, RENDEZVOUS_TAB, CHAT, SEARCH, SAVED_SEARCH }

class MainPageViewModel extends Equatable {
  final bool withChatBadge;
  final bool showRating;

  MainPageViewModel({required this.withChatBadge, required this.showRating});

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    final ratingState = store.state.ratingState;

    return MainPageViewModel(
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
      showRating: ratingState is ShowRatingState,
    );
  }

  @override
  List<Object?> get props => [withChatBadge, showRating];
}
