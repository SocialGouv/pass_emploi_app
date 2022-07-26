import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_actions.dart';
import 'package:pass_emploi_app/models/share_preferences.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/share_preferences_repository.dart';
import 'package:redux/redux.dart';

class SharePreferencesMiddleware extends MiddlewareClass<AppState> {
  final SharePreferencesRepository _repository;

  SharePreferencesMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SharePreferencesRequestAction && loginState is LoginSuccessState) {
      store.dispatch(SharePreferencesLoadingAction());
      final SharePreferences? result = await _repository.getSharePreferences(loginState.user.id);
      if (result != null) {
        store.dispatch(SharePreferencesSuccessAction(result));
      } else {
        store.dispatch(SharePreferencesFailureAction());
      }
    }
  }
}
