import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

abstract class AbstractSearchExtractor<ALERTE_MODEL> {
  ALERTE_MODEL getSearchFilters(Store<AppState> store);

  bool isFailureState(Store<AppState> store);
}

class OffreEmploiSearchExtractor extends AbstractSearchExtractor<OffreEmploiAlerte> {
  @override
  OffreEmploiAlerte getSearchFilters(Store<AppState> store) {
    final state = store.state.rechercheEmploiState;
    final request = state.request!;
    final metier = request.criteres.keyword;
    final location = request.criteres.location;
    return OffreEmploiAlerte(
      id: "",
      title: _setTitleForOffer(metier, location?.libelle),
      metier: metier,
      location: location,
      keyword: metier,
      onlyAlternance: request.criteres.rechercheType.isOnlyAlternance(),
      filters: EmploiFiltresRecherche.withFiltres(
        distance: request.filtres.distance,
        debutantOnly: request.filtres.debutantOnly,
        experience: request.filtres.experience,
        duree: request.filtres.duree,
        contrat: request.filtres.contrat,
      ),
    );
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.offreEmploiAlerteCreateState is AlerteCreateFailureState;
  }

  String _setTitleForOffer(String? metier, String? location) {
    if (_stringWithValue(metier) && _stringWithValue(location)) {
      return Strings.alerteTitleField(metier, location);
    } else if (_stringWithValue(metier)) {
      return metier!;
    } else if (_stringWithValue(location)) {
      return location!;
    } else {
      return '';
    }
  }

  bool _stringWithValue(String? str) => str != null && str.isNotEmpty;
}

class ImmersionSearchExtractor extends AbstractSearchExtractor<ImmersionAlerte> {
  @override
  ImmersionAlerte getSearchFilters(Store<AppState> store) {
    final state = store.state.rechercheImmersionState;
    final String metier = state.request!.criteres.metier.libelle;
    final ville = state.request!.criteres.location.libelle;
    return ImmersionAlerte(
      id: "",
      title: Strings.alerteTitleField(metier, ville),
      metier: metier,
      location: state.request!.criteres.location,
      ville: ville,
      codeRome: state.request!.criteres.metier.codeRome,
      filtres: state.request!.filtres,
    );
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.immersionAlerteCreateState is AlerteCreateFailureState;
  }
}

class ServiceCiviqueSearchExtractor extends AbstractSearchExtractor<ServiceCiviqueAlerte> {
  @override
  ServiceCiviqueAlerte getSearchFilters(Store<AppState> store) {
    final lastRequest = store.state.rechercheServiceCiviqueState.request;
    return ServiceCiviqueAlerte(
      id: "",
      titre: _alerteTitleField(lastRequest),
      location: lastRequest?.criteres.location,
      filtres: ServiceCiviqueFiltresParameters.distance(lastRequest?.filtres.distance),
      ville: lastRequest?.criteres.location?.libelle ?? "",
      domaine: lastRequest?.filtres.domain,
      dateDeDebut: lastRequest?.filtres.startDate,
    );
  }

  String _alerteTitleField(
      RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>? lastRequest) {
    if (lastRequest == null) return "";
    final ville = lastRequest.criteres.location?.libelle;
    final domain = lastRequest.filtres.domain;
    if (ville != null && domain != null) {
      return Strings.alerteTitleField(domain, lastRequest.criteres.location?.libelle);
    } else if (ville != null) {
      return ville;
    } else if (domain != null) {
      return domain.tag;
    } else {
      return "";
    }
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.serviceCiviqueAlerteCreateState is AlerteCreateFailureState;
  }
}
