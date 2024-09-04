import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
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
  final bool useCvm;
  final Function resetDeeplink;
  final String actualisationPoleEmploiUrl;

  MainPageViewModel({
    required this.tabs,
    required this.withChatBadge,
    required this.useCvm,
    required this.resetDeeplink,
    required this.actualisationPoleEmploiUrl,
  });

  factory MainPageViewModel.create(Store<AppState> store) {
    final chatStatusState = store.state.chatStatusState;
    return MainPageViewModel(
      tabs: [
        MainTab.accueil,
        MainTab.monSuivi,
        MainTab.chat,
        MainTab.solutions,
        MainTab.evenements,
      ],
      withChatBadge: (chatStatusState is ChatStatusSuccessState) && (chatStatusState.hasUnreadMessages),
      useCvm: store.state.featureFlipState.featureFlip.useCvm,
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      actualisationPoleEmploiUrl: store.state.configurationState.configuration?.actualisationPoleEmploiUrl ?? "",
    );
  }

  @override
  List<Object?> get props => [tabs, withChatBadge, useCvm];
}
