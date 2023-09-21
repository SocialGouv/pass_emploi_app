import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

//TODO: Reste à faire
// Accueil : OK ?
// Actions : OK ?
// Démarches
// Agenda : OK ?
// Rendezvous
// Favoris
// Alertes
// Events

class CacheInvalidatorMiddleware extends MiddlewareClass<AppState> {
  final PassEmploiCacheManager cacheManager;

  CacheInvalidatorMiddleware(this.cacheManager);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    final userId = store.state.userId() ?? "";

    if (_shouldInvalidateAccueil(action)) {
      await cacheManager.removeResource(CachedResource.ACCUEIL, userId);
    }
    if (_shouldInvalidateUserActionsList(action)) {
      await cacheManager.removeResource(CachedResource.USER_ACTIONS_LIST, userId);
    }

    if (_shouldInvalidateAgenda(action)) {
      await cacheManager.removeResource(CachedResource.AGENDA, userId);
    }

    if (_shouldInvalidateRendezvous(action)) {
      await cacheManager.removeResource(CachedResource.RENDEZVOUS_FUTURS, userId);
      await cacheManager.removeResource(CachedResource.RENDEZVOUS_PASSES, userId);
      await cacheManager.removeResource(CachedResource.SESSIONS_MILO_LIST, userId);
      next(RendezvousListResetAction());
    }

    // TODO: plutôt un shouldInvalidate Sessions ?
    // serait fait uniquement sur Reload Rdv et Events. Pas besoin d'invalider session si on update une action & co.
    // à mettre AVANT le reset RDV ? ou osef de l'ordre ? (le loading sera a priori toujours fait après le next(action) tout en bas)

    next(action);
  }
}

//TODO: il va y avoir des doublons, peut-être qu'il y aura des choses à regrouper
// exemple : Accueil = action request de l'accueil + actions de modif de démarche + actions de modif favoris + ...

bool _shouldInvalidateAccueil(action) {
  return (action is AccueilRequestAction && action.forceRefresh) ||
      action is UserActionCreateSuccessAction ||
      action is UserActionDeleteSuccessAction ||
      action is UserActionUpdateSuccessAction ||
      action is CreateDemarcheSuccessAction ||
      action is UpdateDemarcheSuccessAction ||
      action is FavoriUpdateSuccessAction ||
      action is SavedSearchCreateSuccessAction ||
      action is SavedSearchDeleteSuccessAction ||
      action is AccepterSuggestionRechercheSuccessAction ||
      action is RefuserSuggestionRechercheSuccessAction;
}

bool _shouldInvalidateUserActionsList(action) {
  return (action is UserActionListRequestAction && action.forceRefresh) ||
      action is UserActionCreateSuccessAction ||
      action is UserActionDeleteSuccessAction ||
      action is UserActionUpdateSuccessAction;
}

bool _shouldInvalidateAgenda(action) {
  return (action is AgendaRequestReloadAction && action.forceRefresh) ||
      action is UserActionCreateSuccessAction ||
      action is UserActionDeleteSuccessAction ||
      action is UserActionUpdateSuccessAction ||
      action is CreateDemarcheSuccessAction ||
      action is UpdateDemarcheSuccessAction;
}

bool _shouldInvalidateRendezvous(action) {
  return (action is RendezvousListRequestReloadAction && action.forceRefresh);
}
