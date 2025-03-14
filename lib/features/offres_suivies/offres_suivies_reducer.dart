import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';

OffresSuiviesState offresSuiviesReducer(OffresSuiviesState current, dynamic action) {
  if (action is OffresSuiviesToStateAction) {
    return OffresSuiviesState(
      offresSuivies: List.from(action.offresSuivies),
      confirmationOffre: action.confirmationOffre,
    );
  }
  if (action is OffresSuiviesConfirmationResetAction) {
    return OffresSuiviesState(offresSuivies: current.offresSuivies, confirmationOffre: null);
  }
  return current;
}
