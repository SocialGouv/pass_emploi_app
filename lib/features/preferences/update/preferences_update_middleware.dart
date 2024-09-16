import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/network/put_preferences_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';
import 'package:redux/redux.dart';

class PreferencesUpdateMiddleware extends MiddlewareClass<AppState> {
  final PreferencesRepository _repository;

  PreferencesUpdateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    final preferencesState = store.state.preferencesState;
    if (preferencesState is! PreferencesSuccessState) return;

    if (action is PreferencesUpdateRequestAction) {
      store.dispatch(PreferencesUpdateLoadingAction());
      final success = await _repository.updatePreferences(userId, action.toRequest());
      if (success) {
        store.dispatch(
          PreferencesSuccessAction(
            preferencesState.preferences.copyWith(
              partageFavoris: action.partageFavoris,
              pushNotificationAlertesOffres: action.pushNotificationAlertesOffres,
              pushNotificationMessages: action.pushNotificationMessages,
              pushNotificationCreationAction: action.pushNotificationCreationAction,
              pushNotificationRendezvousSessions: action.pushNotificationRendezvousSessions,
              pushNotificationRappelActions: action.pushNotificationRappelActions,
            ),
          ),
        );
        store.dispatch(PreferencesUpdateSuccessAction());
      } else {
        store.dispatch(PreferencesUpdateFailureAction());
      }
    }
  }
}

extension on PreferencesUpdateRequestAction {
  PutPreferencesRequest toRequest() {
    return PutPreferencesRequest(
      partageFavoris: partageFavoris,
      pushNotificationAlertesOffres: pushNotificationAlertesOffres,
      pushNotificationMessages: pushNotificationMessages,
      pushNotificationCreationAction: pushNotificationCreationAction,
      pushNotificationRendezvousSessions: pushNotificationRendezvousSessions,
      pushNotificationRappelActions: pushNotificationRappelActions,
    );
  }
}
