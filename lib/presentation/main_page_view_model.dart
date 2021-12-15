import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:redux/redux.dart';

enum MainPageDisplayState { DEFAULT, ACTIONS_TAB, RENDEZVOUS_TAB, CHAT }

class MainPageViewModel extends Equatable {
  final bool withChatBadge;

  MainPageViewModel({required this.withChatBadge});

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    return MainPageViewModel(
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.unreadMessageCount > 0),
    );
  }

  @override
  List<Object?> get props => [withChatBadge];
}
