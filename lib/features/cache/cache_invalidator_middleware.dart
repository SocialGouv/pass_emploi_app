import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
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
      await cacheManager.removeResource(CachedResource.accueil, userId);
    }

    if (_shouldInvalidateAnimationsCollectives(action)) {
      await cacheManager.removeResource(CachedResource.animationsCollectives, userId);
    }

    if (_shouldInvalidateSessionsMiloInscrit(action)) {
      await cacheManager.removeResource(CachedResource.sessionsMiloInscrit, userId);
    }

    if (_shouldInvalidateSessionsMiloList(action)) {
      await cacheManager.removeResource(CachedResource.sessionsMiloList, userId);
    }

    if (_shouldInvalidateFavoris(action)) {
      await cacheManager.removeAllFavorisResources();
    }

    if (_shouldInvalidateAlertes(action)) {
      await cacheManager.removeResource(CachedResource.alerte, userId);
    }

    if (_shouldInvalidatePreferences(action)) {
      await cacheManager.removeResource(CachedResource.preferences, userId);
    }

    if (_shouldInvalidateUserAction(action)) {
      await cacheManager.removeResource(CachedResource.userAction, userId);
    }

    next(action);
  }
}

bool _shouldInvalidateUserAction(dynamic action) {
  return action is UserActionUpdateSuccessAction;
}

bool _shouldInvalidateAccueil(Store<AppState> store, dynamic action) {
  return (action is AccueilRequestAction && action.forceRefresh) ||
      action is UserActionCreateSuccessAction ||
      action is UserActionDeleteSuccessAction ||
      action is UserActionUpdateSuccessAction ||
      action is CreateDemarcheSuccessAction ||
      action is UpdateDemarcheSuccessAction ||
      action is FavoriUpdateSuccessAction ||
      action is AlerteCreateSuccessAction ||
      action is AlerteDeleteSuccessAction ||
      action is AccepterSuggestionRechercheSuccessAction ||
      action is RefuserSuggestionRechercheSuccessAction ||
      _newUserActionsCreated(store, action) ||
      _isExternalDeepLinkOf<ActionDeepLink>(action) ||
      _isExternalDeepLinkOf<RendezvousDeepLink>(action) ||
      _isExternalDeepLinkOf<SessionMiloDeepLink>(action) ||
      _isExternalDeepLinkOf<AlerteDeepLink>(action);
}

bool _shouldInvalidateAnimationsCollectives(dynamic action) {
  return (action is EventListRequestAction && action.forceRefresh);
}

bool _shouldInvalidateSessionsMiloInscrit(dynamic action) {
  return _isExternalDeepLinkOf<RendezvousDeepLink>(action) || _isExternalDeepLinkOf<SessionMiloDeepLink>(action);
}

bool _shouldInvalidateSessionsMiloList(dynamic action) {
  return (action is EventListRequestAction && action.forceRefresh) ||
      _isExternalDeepLinkOf<SessionMiloDeepLink>(action);
}

bool _shouldInvalidateFavoris(dynamic action) {
  return action is FavoriUpdateSuccessAction;
}

bool _shouldInvalidateAlertes(dynamic action) {
  return (action is AlerteCreateSuccessAction ||
          action is AlerteDeleteSuccessAction ||
          action is AccepterSuggestionRechercheSuccessAction ||
          action is RefuserSuggestionRechercheSuccessAction) ||
      _isExternalDeepLinkOf<AlerteDeepLink>(action);
}

bool _shouldInvalidatePreferences(dynamic action) {
  return action is PreferencesUpdateSuccessAction;
}

bool _newUserActionsCreated(Store<AppState> store, dynamic action) {
  if (action is! UserActionCreatePendingAction) return false;
  return action.pendingCreationsCount < store.state.userActionCreatePendingState.getPendingCreationsCount();
}

bool _isExternalDeepLinkOf<T>(dynamic action) {
  return action is HandleDeepLinkAction && action.origin.isInAppNavigation == false && action.deepLink is T;
}
