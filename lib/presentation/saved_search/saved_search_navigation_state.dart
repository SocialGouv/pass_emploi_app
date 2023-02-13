import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

enum SavedSearchNavigationState {
  OFFRE_EMPLOI,
  OFFRE_IMMERSION,
  OFFRE_ALTERNANCE,
  SERVICE_CIVIQUE,
  NONE;

  static SavedSearchNavigationState fromAppState(AppState state) {
    final offreEmploiListState = state.offreEmploiListState;
    final searchParamsState = state.offreEmploiSearchParametersState;
    if ((offreEmploiListState is OffreEmploiListSuccessState &&
        searchParamsState is OffreEmploiSearchParametersInitializedState)) {
      return searchParamsState.onlyAlternance
          ? SavedSearchNavigationState.OFFRE_ALTERNANCE
          : SavedSearchNavigationState.OFFRE_EMPLOI;
    } else if (state.rechercheImmersionState.status == RechercheStatus.success) {
      return SavedSearchNavigationState.OFFRE_IMMERSION;
    } else if (state.rechercheServiceCiviqueState.status == RechercheStatus.success) {
      return SavedSearchNavigationState.SERVICE_CIVIQUE;
    } else {
      return SavedSearchNavigationState.NONE;
    }
  }
}
