import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';
import 'package:redux/redux.dart';

class PreferencesUpdateMiddleware extends MiddlewareClass<AppState> {
  final PreferencesRepository _repository;

  PreferencesUpdateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is PreferencesUpdateRequestAction && loginState is LoginSuccessState) {
      store.dispatch(PreferencesUpdateLoadingAction(action.favorisShared));
      final result = await _repository.updatePreferences(
        loginState.user.id,
        action.favorisShared,
      );
      if (result) {
        store.dispatch(PreferencesUpdateSuccessAction(action.favorisShared));
      } else {
        store.dispatch(PreferencesUpdateFailureAction(action.favorisShared));
      }
    }
  }
}
