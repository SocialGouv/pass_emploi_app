import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:redux/redux.dart';

class AccueilMiddleware extends MiddlewareClass<AppState> {
  final AccueilRepository _repository;

  AccueilMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    // Need to be done before the action is dispatched to the reducer
    final int currentPendingActionsCount = store.state.userActionCreatePendingState.getPendingCreationsCount();

    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (_needFetchingAccueil(currentPendingActionsCount, action)) {
      store.dispatch(AccueilLoadingAction());
      final result = await getAccueil(user);
      store.dispatch(result != null ? AccueilSuccessAction(result) : AccueilFailureAction());
      store.dispatch(CampagneFetchedAction(result?.campagne));
      store.dispatch(CampagneRecrutementRequestAction());
    }
  }

  Future<Accueil?> getAccueil(User user) {
    if (user.loginMode.isPe()) {
      return _repository.getAccueilPoleEmploi(user.id, DateTime.now());
    }
    return _repository.getAccueilMissionLocale(user.id, DateTime.now());
  }
}

bool _needFetchingAccueil(int currentPendingActionsCount, dynamic action) {
  return action is AccueilRequestAction ||
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
      _newUserActionsCreated(currentPendingActionsCount, action);
}

bool _newUserActionsCreated(int currentPendingActionsCount, dynamic action) {
  if (action is! UserActionCreatePendingAction) return false;
  return action.pendingCreationsCount < currentPendingActionsCount;
}
