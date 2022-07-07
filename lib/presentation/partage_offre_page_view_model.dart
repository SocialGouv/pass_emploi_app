import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage_offre/partage_offre_actions.dart';
import 'package:pass_emploi_app/features/chat/partage_offre/partage_offre_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PartageOffrePageViewModel extends Equatable {
  final String offreTitle;
  final DisplayState snackbarState;
  final Function(String message, OffreType type) onPartagerOffre;
  final Function snackbarDisplayed;

  PartageOffrePageViewModel({
    required this.offreTitle,
    required this.snackbarState,
    required this.onPartagerOffre,
    required this.snackbarDisplayed,
  });

  factory PartageOffrePageViewModel.create(Store<AppState> store) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is! OffreEmploiDetailsSuccessState) {
      throw Exception("PartageOffrePageViewModel must be created with a OffreEmploiDetailsSuccessState.");
    }
    return PartageOffrePageViewModel(
      offreTitle: offreEmploiDetailsState.offre.title,
      snackbarState: _snackbarState(store),
      onPartagerOffre: (message, isAlternance) => _partagerOffre(store, offreEmploiDetailsState.offre, message, isAlternance),
      snackbarDisplayed: () => store.dispatch(ChatPartageOffreResetAction()),
    );
  }

  @override
  List<Object?> get props => [offreTitle, snackbarState];
}

DisplayState _snackbarState(Store<AppState> store) {
  switch (store.state.chatPartageOffreState) {
    case ChatPartageOffreState.notInitialized:
      return DisplayState.EMPTY;
    case ChatPartageOffreState.loading:
      return DisplayState.LOADING;
    case ChatPartageOffreState.success:
      return DisplayState.CONTENT;
    case ChatPartageOffreState.failure:
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
