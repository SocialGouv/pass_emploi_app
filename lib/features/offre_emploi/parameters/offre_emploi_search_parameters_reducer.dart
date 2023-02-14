import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/saved_search/offre_emploi_saved_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';

OffreEmploiSearchParametersState offreEmploiSearchParametersReducer(
  OffreEmploiSearchParametersState current,
  dynamic action,
) {
  if (action is SavedOffreEmploiSearchRequestAction) {
    return OffreEmploiSearchParametersState.initialized(
      keywords: action.keywords,
      location: action.location,
      onlyAlternance: action.onlyAlternance,
      filtres: action.filtres,
    );
  } else if (action is OffreEmploiSearchRequestAction) {
    return OffreEmploiSearchParametersInitializedState(
      keywords: action.keywords,
      location: action.location,
      onlyAlternance: action.onlyAlternance,
      filtres: EmploiFiltresRecherche.noFiltre(),
    );
  } else if (action is OffreEmploiSearchParametersUpdateFiltresRequestAction) {
    if (current is OffreEmploiSearchParametersInitializedState) {
      return OffreEmploiSearchParametersInitializedState(
        keywords: current.keywords,
        location: current.location,
        onlyAlternance: current.onlyAlternance,
        filtres: action.updatedFiltres,
      );
    } else {
      return current;
    }
  } else if (action is OffreEmploiSearchParametersUpdateFiltresFailureAction) {
    if (current is OffreEmploiSearchParametersInitializedState) {
      return OffreEmploiSearchParametersState.initialized(
        keywords: current.keywords,
        location: current.location,
        onlyAlternance: current.onlyAlternance,
        filtres: EmploiFiltresRecherche.noFiltre(),
      );
    } else {
      return current;
    }
  } else {
    return current;
  }
}
