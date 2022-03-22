import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';

OffreEmploiDetailsState offreEmploiDetailsReducer(OffreEmploiDetailsState current, dynamic action) {
  if (action is OffreEmploiDetailsIncompleteDataAction) return OffreEmploiDetailsIncompleteDataState(action.offre);
  if (action is OffreEmploiDetailsLoadingAction) return OffreEmploiDetailsLoadingState();
  if (action is OffreEmploiDetailsFailureAction) return OffreEmploiDetailsFailureState();
  if (action is OffreEmploiDetailsSuccessAction) return OffreEmploiDetailsSuccessState(action.offre);
  if (action is OffreEmploiDetailsResetAction) return OffreEmploiDetailsNotInitializedState();
  return current;
}
