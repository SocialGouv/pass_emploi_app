import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

AppState offreEmploiDetailsReducer(AppState currentState, OffreEmploiDetailsAction action) {
  if (action is OffreEmploiDetailsLoadingAction) {
    return currentState.copyWith(offreEmploiDetailsState: State<OffreEmploiDetails>.loading());
  } else if (action is OffreEmploiDetailsSuccessAction) {
    return currentState.copyWith(offreEmploiDetailsState: State<OffreEmploiDetails>.success(action.offre));
  } else if (action is OffreEmploiDetailsFailureAction) {
    return currentState.copyWith(offreEmploiDetailsState: State<OffreEmploiDetails>.failure());
  } else if (action is OffreEmploiDetailsIncompleteDataAction) {
    return currentState.copyWith(offreEmploiDetailsState: OffreEmploiDetailsIncompleteDataState(action.offre));
  } else {
    return currentState;
  }
}
