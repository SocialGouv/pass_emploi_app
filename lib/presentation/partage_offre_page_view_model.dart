import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PartageOffrePageViewModel {
  final String offreTitle;
  final Function(String message) onPartagerOffre;

  PartageOffrePageViewModel({required this.offreTitle, required this.onPartagerOffre});

  factory PartageOffrePageViewModel.create(Store<AppState> store) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is! OffreEmploiDetailsSuccessState) {
      throw Exception("PartageOffrePageViewModel must be created with a OffreEmploiDetailsSuccessState.");
    }
    return PartageOffrePageViewModel(
      offreTitle: offreEmploiDetailsState.offre.title,
      onPartagerOffre: (message) => {_partagerOffre(store, offreEmploiDetailsState.offre, message)},
    );
  }
}

void _partagerOffre(Store<AppState> store, OffreEmploiDetails offre, String message) {
  store.dispatch(
    ChatPartagerOffreAction(
      OffrePartagee(
        id: offre.id,
        titre: offre.title,
        url: offre.urlRedirectPourPostulation,
        message: message,
      ),
    ),
  );
}
