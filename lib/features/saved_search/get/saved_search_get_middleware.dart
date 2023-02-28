import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchGetMiddleware extends MiddlewareClass<AppState> {
  final GetSavedSearchRepository _repository;

  SavedSearchGetMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SavedSearchGetAction && loginState is LoginSuccessState) {
      final search = (await _repository.getSavedSearch(loginState.user.id))
          ?.where((e) => e.getId() == action.savedSearchId)
          .firstOrNull;
      if (search == null) return;
      if (search is ImmersionSavedSearch) _handleImmersionSavedSearch(search, store);
      if (search is OffreEmploiSavedSearch) _handleEmploiSavedSearch(search, store);
      if (search is ServiceCiviqueSavedSearch) _handleServiceCiviqueSavedSearch(search, store);
    }
  }

  void _handleEmploiSavedSearch(OffreEmploiSavedSearch search, Store<AppState> store) {
    store.dispatch(
      RechercheRequestAction(
        RechercheRequest(
          EmploiCriteresRecherche(
            keyword: search.keyword ?? '',
            location: search.location,
            onlyAlternance: search.onlyAlternance,
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

  void _handleServiceCiviqueSavedSearch(ServiceCiviqueSavedSearch search, Store<AppState> store) {
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

  void _handleImmersionSavedSearch(ImmersionSavedSearch search, Store<AppState> store) {
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
