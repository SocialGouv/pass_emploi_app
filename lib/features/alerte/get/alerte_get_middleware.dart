import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:redux/redux.dart';

class AlerteGetMiddleware extends MiddlewareClass<AppState> {
  final GetAlerteRepository _repository;

  AlerteGetMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;

    if (action is FetchAlerteResultsFromIdAction) {
      final search = (await _repository.getAlerte(userId)) //
          ?.where((e) => e.getId() == action.alerteId)
          .firstOrNull;
      if (search == null) return;
      _handleAlerte(search, store);
    } else if (action is FetchAlerteResultsAction) {
      _handleAlerte(action.alerte, store);
    }
  }

  void _handleAlerte(Alerte search, Store<AppState> store) {
    if (search is ImmersionAlerte) _handleImmersionAlerte(search, store);
    if (search is OffreEmploiAlerte) _handleEmploiAlerte(search, store);
    if (search is ServiceCiviqueAlerte) _handleServiceCiviqueAlerte(search, store);
  }

  void _handleEmploiAlerte(OffreEmploiAlerte search, Store<AppState> store) {
    store.dispatch(
      RechercheRequestAction(
        RechercheRequest(
          EmploiCriteresRecherche(
            keyword: search.keyword ?? '',
            location: search.location,
            rechercheType: RechercheType.from(search.onlyAlternance),
          ),
          EmploiFiltresRecherche.withFiltres(
            distance: search.filters.distance,
            debutantOnly: search.filters.debutantOnly,
            experience: search.filters.experience,
            contrat: search.filters.contrat,
            duree: search.filters.duree,
          ),
          1,
        ),
      ),
    );
  }

  void _handleServiceCiviqueAlerte(ServiceCiviqueAlerte search, Store<AppState> store) {
    store.dispatch(
      RechercheRequestAction(
        RechercheRequest(
          ServiceCiviqueCriteresRecherche(location: search.location),
          ServiceCiviqueFiltresRecherche(
            distance: search.filtres.distance,
            startDate: search.dateDeDebut,
            domain: search.domaine,
          ),
          1,
        ),
      ),
    );
  }

  void _handleImmersionAlerte(ImmersionAlerte search, Store<AppState> store) {
    store.dispatch(
      RechercheRequestAction(
        RechercheRequest(
          ImmersionCriteresRecherche(
            location: search.location,
            metier: Metier(codeRome: search.codeRome, libelle: search.metier),
          ),
          ImmersionFiltresRecherche.distance(search.filtres.distance),
          1,
        ),
      ),
    );
  }
}
