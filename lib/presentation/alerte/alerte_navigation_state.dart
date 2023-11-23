import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

enum AlerteNavigationState {
  OFFRE_EMPLOI,
  OFFRE_IMMERSION,
  OFFRE_ALTERNANCE,
  SERVICE_CIVIQUE,
  NONE;

  static AlerteNavigationState fromAppState(AppState state) {
    if (state.rechercheEmploiState.status == RechercheStatus.success) {
      return state.rechercheEmploiState.request?.criteres.rechercheType.isOnlyAlternance() == true
          ? AlerteNavigationState.OFFRE_ALTERNANCE
          : AlerteNavigationState.OFFRE_EMPLOI;
    } else if (state.rechercheImmersionState.status == RechercheStatus.success) {
      return AlerteNavigationState.OFFRE_IMMERSION;
    } else if (state.rechercheServiceCiviqueState.status == RechercheStatus.success) {
      return AlerteNavigationState.SERVICE_CIVIQUE;
    } else {
      return AlerteNavigationState.NONE;
    }
  }
}
