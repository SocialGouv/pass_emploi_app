import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CacheInvalidatorMiddleware extends MiddlewareClass<AppState> {
  final PassEmploiCacheManager cacheManager;

  CacheInvalidatorMiddleware(this.cacheManager);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    final userId = store.state.userId() ?? "";

    if (_shouldInvalidateAccueil(store, action)) {
      await cacheManager.removeResource(CachedResource.ACCUEIL, userId);
    }

    if (_shouldInvalidateUserActionsList(store, action)) {
      await cacheManager.removeResource(CachedResource.USER_ACTIONS_LIST, userId);
    }

    if (_shouldInvalidateDemarchesList(action)) {
      await cacheManager.removeResource(CachedResource.DEMARCHES_LIST, userId);
    }

    if (_shouldInvalidateAgenda(store, action)) {
      await cacheManager.removeResource(CachedResource.AGENDA, userId);
    }

    if (_shouldInvalidateRendezvous(action)) {
      await cacheManager.removeResource(CachedResource.RENDEZVOUS_FUTURS, userId);
      await cacheManager.removeResource(CachedResource.RENDEZVOUS_PASSES, userId);
      await cacheManager.removeResource(CachedResource.SESSIONS_MILO_INSCRIT, userId);
      next(RendezvousListResetAction());
    }

    if (_shouldInvalidateEvents(action)) {
      await cacheManager.removeResource(CachedResource.ANIMATIONS_COLLECTIVES, userId);
      await cacheManager.removeResource(CachedResource.SESSIONS_MILO_LIST, userId);
    }

    if (_shouldInvalidateFavoris(action)) {
      await cacheManager.removeAllFavorisResources();
    }

    if (_shouldInvalidateAlertes(action)) {
      await cacheManager.removeResource(CachedResource.SAVED_SEARCH, userId);
    }

    if (_shouldInvalidatePartageActivite(action)) {
      await cacheManager.removeResource(CachedResource.UPDATE_PARTAGE_ACTIVITE, userId);
    }

    next(action);
  }
}

bool _shouldInvalidateAccueil(Store<AppState> store, dynamic action) {
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
      action is RefuserSuggestionRechercheSuccessAction ||
      _newUserActionsCreated(store, action);
}

bool _shouldInvalidateAgenda(Store<AppState> store, dynamic action) {
  return (action is AgendaRequestReloadAction && action.forceRefresh) ||
      action is UserActionCreateSuccessAction ||
      action is UserActionDeleteSuccessAction ||
      action is UserActionUpdateSuccessAction ||
      action is CreateDemarcheSuccessAction ||
      action is UpdateDemarcheSuccessAction ||
      _newUserActionsCreated(store, action);
}

bool _shouldInvalidateUserActionsList(Store<AppState> store, dynamic action) {
  return (action is UserActionListRequestAction && action.forceRefresh) ||
      action is UserActionCreateSuccessAction ||
      action is UserActionDeleteSuccessAction ||
      action is UserActionUpdateSuccessAction ||
      _newUserActionsCreated(store, action);
}

bool _shouldInvalidateDemarchesList(dynamic action) {
  return (action is DemarcheListRequestReloadAction && action.forceRefresh) ||
      action is CreateDemarcheSuccessAction ||
      action is UpdateDemarcheSuccessAction;
}

bool _shouldInvalidateRendezvous(dynamic action) {
  return (action is RendezvousListRequestReloadAction && action.forceRefresh);
}

bool _shouldInvalidateEvents(dynamic action) {
  return (action is EventListRequestAction && action.forceRefresh);
}

bool _shouldInvalidateFavoris(dynamic action) {
  return action is FavoriUpdateSuccessAction;
}

bool _shouldInvalidateAlertes(dynamic action) {
  return (action is SavedSearchCreateSuccessAction ||
      action is SavedSearchDeleteSuccessAction ||
      action is AccepterSuggestionRechercheSuccessAction ||
      action is RefuserSuggestionRechercheSuccessAction);
}

bool _shouldInvalidatePartageActivite(dynamic action) {
  return action is PartageActiviteUpdateRequestAction;
}

bool _newUserActionsCreated(Store<AppState> store, dynamic action) {
  if (action is! UserActionCreatePendingAction) return false;
  return action.pendingCreationsCount < store.state.userActionCreatePendingState.getPendingCreationsCount();
}
