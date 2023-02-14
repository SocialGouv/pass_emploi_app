import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiDataFromIdExtractor extends DataFromIdExtractor<OffreEmploi> {
  @override
  OffreEmploi extractFromId(Store<AppState> store, String favoriId) {
    final state = store.state.rechercheEmploiState;
    return state.results!.firstWhere((element) => element.id == favoriId);
  }
}

class ImmersionDataFromIdExtractor extends DataFromIdExtractor<Immersion> {
  @override
  Immersion extractFromId(Store<AppState> store, String favoriId) {
    return store.state.rechercheImmersionState.results!.firstWhere((element) => element.id == favoriId);
  }
}

class ServiceCiviqueDataFromIdExtractor extends DataFromIdExtractor<ServiceCivique> {
  @override
  ServiceCivique extractFromId(Store<AppState> store, String favoriId) {
    return store.state.rechercheServiceCiviqueState.results!.firstWhere((element) => element.id == favoriId);
  }
}
