import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiDataFromIdExtractor extends DataFromIdExtractor<OffreEmploi> {
  @override
  OffreEmploi extractFromId(Store<AppState> store, String favoriId) {
    final isOffreSuivie =
        store.state.offresSuiviesState.offresSuivies.firstWhereOrNull((element) => element.offreDto.id == favoriId);

    if (isOffreSuivie != null && isOffreSuivie.offreDto is OffreEmploiDto) {
      return (isOffreSuivie.offreDto as OffreEmploiDto).offreEmploi;
    }

    final state = store.state.rechercheEmploiState;
    if (state.results != null) {
      return state.results!.firstWhere((element) => element.id == favoriId);
    }

    if (store.state.offreEmploiDetailsState is OffreEmploiDetailsSuccessState) {
      return (store.state.offreEmploiDetailsState as OffreEmploiDetailsSuccessState).offre.toOffreEmploi;
    }

    throw Exception("No offre emploi found with id $favoriId");
  }
}

class ImmersionDataFromIdExtractor extends DataFromIdExtractor<Immersion> {
  @override
  Immersion extractFromId(Store<AppState> store, String favoriId) {
    final state = store.state.rechercheImmersionState;
    if (state.results == null) {
      return (store.state.immersionDetailsState as ImmersionDetailsSuccessState).immersion.toImmersion;
    }
    return state.results!.firstWhere((element) => element.id == favoriId);
  }
}

class ServiceCiviqueDataFromIdExtractor extends DataFromIdExtractor<ServiceCivique> {
  @override
  ServiceCivique extractFromId(Store<AppState> store, String favoriId) {
    final state = store.state.rechercheServiceCiviqueState;
    if (state.results == null) {
      return (store.state.serviceCiviqueDetailState as ServiceCiviqueDetailSuccessState).detail.toServiceCivique;
    }
    return state.results!.firstWhere((element) => element.id == favoriId);
  }
}
