import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiDataFromIdExtractor extends DataFromIdExtractor<OffreEmploi> {
  @override
  OffreEmploi extractFromId(Store<AppState> store, String favoriId) {
    if (store.state.offreEmploiListState is OffreEmploiListSuccessState) {
      //TODO(1353): encore utile ce if ou à virer après nettoyage ?
      final state = store.state.offreEmploiListState as OffreEmploiListSuccessState;
      return state.offres.firstWhere((element) => element.id == favoriId);
    }
    // TODO : 1353 - Test later when offreEmploiListState would be removed
    final state = store.state.rechercheEmploiState;
    return state.results!.firstWhere((element) => element.id == favoriId);
  }
}

class ImmersionDataFromIdExtractor extends DataFromIdExtractor<Immersion> {
  @override
  Immersion extractFromId(Store<AppState> store, String favoriId) {
    if (store.state.immersionListState is ImmersionListSuccessState) {
      //TODO(1356): encore utile ce if ou à virer après nettoyage ?
      final state = store.state.immersionListState as ImmersionListSuccessState;
      return state.immersions.firstWhere((element) => element.id == favoriId);
    }
    // TODO : 1356 - Test later when offreEmploiListState would be removed
    return store.state.rechercheImmersionState.results!.firstWhere((element) => element.id == favoriId);
  }
}

class ServiceCiviqueDataFromIdExtractor extends DataFromIdExtractor<ServiceCivique> {
  @override
  ServiceCivique extractFromId(Store<AppState> store, String favoriId) {
    if (store.state.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultDataState) {
      //TODO(1355): encore utile ce if ou à virer après nettoyage ?
      final state = store.state.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState;
      return state.offres.firstWhere((element) => element.id == favoriId);
    }
    // TODO : 1355 - Test later when offreEmploiListState would be removed
    return store.state.rechercheServiceCiviqueState.results!.firstWhere((element) => element.id == favoriId);
  }
}
