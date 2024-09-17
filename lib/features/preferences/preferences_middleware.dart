import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';
import 'package:redux/redux.dart';

class PreferencesMiddleware extends MiddlewareClass<AppState> {
  final PreferencesRepository _repository;

  PreferencesMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is PreferencesRequestAction && loginState is LoginSuccessState) {
      store.dispatch(PreferencesLoadingAction());
      final Preferences? result = await _repository.getPreferences(loginState.user.id);
      if (result != null) {
        store.dispatch(PreferencesSuccessAction(result));
      } else {
        store.dispatch(PreferencesFailureAction());
      }
    }
  }
}
