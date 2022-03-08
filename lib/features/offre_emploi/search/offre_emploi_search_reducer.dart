import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';

OffreEmploiSearchState offreEmploiSearchReducer(OffreEmploiSearchState current, dynamic action) {
  if (action is OffreEmploiSearchLoadingAction) return OffreEmploiSearchState.loading();
  if (action is OffreEmploiSearchSuccessAction) return OffreEmploiSearchState.success();
  if (action is OffreEmploiSearchWithUpdateFiltresSuccessAction) return OffreEmploiSearchState.success();
  if (action is OffreEmploiSearchFailureAction) return OffreEmploiSearchState.failure();
  if (action is OffreEmploiSearchWithUpdateFiltresFailureAction) return OffreEmploiSearchState.failure();
  if (action is OffreEmploiSearchResetAction) return OffreEmploiSearchState.notInitialized();
  return current;
}
