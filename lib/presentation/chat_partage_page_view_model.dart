import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChatPartagePageViewModel extends Equatable {
  final String shareableTitle;
  final DisplayState snackbarState;
  final Function(String message, OffreType type) onShare;
  final Function snackbarDisplayed;

  ChatPartagePageViewModel({
    required this.shareableTitle,
    required this.snackbarState,
    required this.onShare,
    required this.snackbarDisplayed,
  });

  factory ChatPartagePageViewModel.sharingOffre(Store<AppState> store) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is! OffreEmploiDetailsSuccessState) {
      throw Exception("ChatPartagePageViewModel must be created with a OffreEmploiDetailsSuccessState.");
    }
    return ChatPartagePageViewModel(
      shareableTitle: offreEmploiDetailsState.offre.title,
      snackbarState: _snackbarState(store),
      onShare: (message, isAlternance) =>
          _partagerOffre(store, offreEmploiDetailsState.offre, message, isAlternance),
      snackbarDisplayed: () => store.dispatch(ChatPartageResetAction()),
    );
  }

  @override
  List<Object?> get props => [shareableTitle, snackbarState];
}

DisplayState _snackbarState(Store<AppState> store) {
  switch (store.state.chatPartageState) {
    case ChatPartageState.notInitialized:
      return DisplayState.EMPTY;
    case ChatPartageState.loading:
      return DisplayState.LOADING;
    case ChatPartageState.success:
      return DisplayState.CONTENT;
    case ChatPartageState.failure:
      return DisplayState.FAILURE;
  }
}

void _partagerOffre(Store<AppState> store, OffreEmploiDetails offre, String message, OffreType type) {
  store.dispatch(
    ChatPartagerOffreAction(
      OffrePartagee(
        id: offre.id,
        titre: offre.title,
        url: offre.urlRedirectPourPostulation,
        message: message,
        type: type,
      ),
    ),
  );
}
