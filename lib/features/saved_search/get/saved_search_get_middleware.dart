import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/saved_search/offre_emploi_saved_search_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
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
      if (search is ImmersionSavedSearch) store.dispatch(ImmersionSavedSearchRequestAction.fromSearch(search));
      if (search is OffreEmploiSavedSearch) store.dispatch(SavedOffreEmploiSearchRequestAction.fromSearch(search));
      if (search is ServiceCiviqueSavedSearch) {
        final criteres = ServiceCiviqueCriteresRecherche(location: search.location);
        final filtres = ServiceCiviqueFiltresRecherche(
          distance: search.filtres.distance,
          startDate: search.dateDeDebut,
          domain: search.domaine,
        );
        store.dispatch(RechercheRequestAction(RechercheRequest(criteres, filtres, 1)));
      }
    }
  }
}
