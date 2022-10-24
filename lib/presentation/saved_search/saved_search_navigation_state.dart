import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
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
    final immersionListState = state.immersionListState;
    final serviceCiviqueSearchResultState = state.serviceCiviqueSearchResultState;
    if ((offreEmploiListState is OffreEmploiListSuccessState &&
        searchParamsState is OffreEmploiSearchParametersInitializedState)) {
      return searchParamsState.onlyAlternance
          ? SavedSearchNavigationState.OFFRE_ALTERNANCE
          : SavedSearchNavigationState.OFFRE_EMPLOI;
    } else if (immersionListState is ImmersionListSuccessState) {
      return SavedSearchNavigationState.OFFRE_IMMERSION;
    } else if (serviceCiviqueSearchResultState is ServiceCiviqueSearchResultDataState) {
      return SavedSearchNavigationState.SERVICE_CIVIQUE;
    } else {
      return SavedSearchNavigationState.NONE;
    }
  }
}
