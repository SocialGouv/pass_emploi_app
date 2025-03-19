import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class OffreSuivieFormViewmodel extends Equatable {
  final bool fromAlternance;
  final String dateConsultation;
  final String? offreLien;
  final void Function() onPostule;
  final void Function() onInteresse;
  final void Function() onNotInterested;
  final void Function() onHideForever;
  final bool showConfirmation;
  final String? confirmationMessage;
  final String confirmationButton;

  OffreSuivieFormViewmodel._({
    required this.fromAlternance,
    required this.dateConsultation,
    required this.offreLien,
    required this.onPostule,
    required this.onInteresse,
    required this.onNotInterested,
    required this.onHideForever,
    required this.showConfirmation,
    required this.confirmationMessage,
    required this.confirmationButton,
  });

  factory OffreSuivieFormViewmodel.create(Store<AppState> store, String offreId, bool isHomePage) {
    final offreSuivie = store.state.offresSuiviesState.getOffre(offreId);
    return OffreSuivieFormViewmodel._(
      fromAlternance: offreSuivie != null && offreSuivie.offreDto.isAlternance,
      dateConsultation: offreSuivie != null ? _dateConsultation(offreSuivie) : "",
      offreLien: offreSuivie != null ? _offreLien(offreSuivie, isHomePage) : null,
      onPostule: () {
        store.dispatch(FavoriUpdateRequestAction<OffreEmploi>(offreId, FavoriStatus.applied));
        if (offreSuivie != null) store.dispatch(OffresSuiviesDeleteAction(offreSuivie));
      },
      onInteresse: () {
        store.dispatch(FavoriUpdateRequestAction<OffreEmploi>(offreId, FavoriStatus.added));
        if (offreSuivie != null) store.dispatch(OffresSuiviesDeleteAction(offreSuivie));
      },
      onNotInterested: offreSuivie != null ? () => store.dispatch(OffresSuiviesDeleteAction(offreSuivie)) : () {},
      onHideForever: () => store.dispatch(OffresSuiviesConfirmationResetAction()),
      showConfirmation: store.state.offresSuiviesState.confirmationOffre?.offreDto.id == offreId,
      confirmationMessage: _confirmationMessage(store, offreId),
      confirmationButton: _confirmationButton(store, offreId, isHomePage),
    );
  }

  @override
  List<Object?> get props => [
        dateConsultation,
        offreLien,
      ];
}

String _dateConsultation(OffreSuivie offreSuivie) {
  return Strings.youConsultedThisOfferAt(offreSuivie.dateConsultation.timeAgo());
}

String? _offreLien(OffreSuivie offreSuivie, bool showOffreDetails) {
  if (showOffreDetails) {
    return offreSuivie.offreDto.title;
  }
  return null;
}

String? _confirmationMessage(Store<AppState> store, String offreId) {
  final isOffreFavoris = store.state.offreEmploiFavorisIdsState.contains(offreId);
  return isOffreFavoris ? Strings.retrouvezCetteOffreDansVosOffres : null;
}

String _confirmationButton(Store<AppState> store, String offreId, bool isHomePage) {
  if (isHomePage) {
    return store.state.offresSuiviesState.offresSuivies.isNotEmpty ? Strings.seeNextOffer : Strings.close;
  }

  return Strings.close;
}
