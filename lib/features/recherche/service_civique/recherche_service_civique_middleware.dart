import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

class RechercheServiceCiviqueMiddleware
    extends RechercheMiddleware<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique> {
  final ServiceCiviqueRepository _repository;

  RechercheServiceCiviqueMiddleware(this._repository);

  @override
  RechercheState<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique> getRechercheState(
    AppState state,
  ) {
    return state.rechercheServiceCiviqueState;
  }

  @override
  RechercheRepository<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique> getRepository() {
    return _repository;
  }
}
