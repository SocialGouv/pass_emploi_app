import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

enum SavedSearchNavigationState {
  OFFRE_EMPLOI,
  OFFRE_IMMERSION,
  OFFRE_ALTERNANCE,
  SERVICE_CIVIQUE,
  NONE;

  static SavedSearchNavigationState fromAppState(AppState state) {
    if (state.rechercheEmploiState.status == RechercheStatus.success) {
      return state.rechercheEmploiState.request?.criteres.onlyAlternance == true
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
