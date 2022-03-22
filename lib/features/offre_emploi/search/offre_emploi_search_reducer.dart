import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';

OffreEmploiSearchState offreEmploiSearchReducer(OffreEmploiSearchState current, dynamic action) {
  if (action is OffreEmploiSearchLoadingAction) return OffreEmploiSearchState.loading();
  if (action is OffreEmploiSearchSuccessAction) return OffreEmploiSearchState.success();
  if (action is OffreEmploiSearchParametersUpdateFiltresSuccessAction) return OffreEmploiSearchState.success();
  if (action is OffreEmploiSearchFailureAction) return OffreEmploiSearchState.failure();
  if (action is OffreEmploiSearchParametersUpdateFiltresFailureAction) return OffreEmploiSearchState.failure();
  if (action is OffreEmploiSearchResetAction) return OffreEmploiSearchState.notInitialized();
  return current;
}
