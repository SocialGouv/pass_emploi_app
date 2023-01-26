import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';

OffreEmploiListState offreEmploiListReducer(OffreEmploiListState current, dynamic action) {
  if (action is OffreEmploiSearchResetAction || action is OffreEmploiListResetAction) {
    return OffreEmploiListState.notInitialized();
  } else if (action is OffreEmploiSearchSuccessAction) {
    return OffreEmploiListState.data(
      offres: current is OffreEmploiListSuccessState ? current.offres + action.offres : action.offres,
      loadedPage: action.page,
      isMoreDataAvailable: action.isMoreDataAvailable,
    );
  } else if (action is OffreEmploiSearchParametersUpdateFiltresSuccessAction) {
    return OffreEmploiListState.data(
      offres: action.offres,
      loadedPage: action.page,
      isMoreDataAvailable: action.isMoreDataAvailable,
    );
  } else {
    return current;
  }
}
