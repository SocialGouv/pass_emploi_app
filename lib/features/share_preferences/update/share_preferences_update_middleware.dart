import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/share_preferences_repository.dart';
import 'package:redux/redux.dart';

class SharePreferencesUpdateMiddleware extends MiddlewareClass<AppState> {
  final SharePreferencesRepository _repository;

  SharePreferencesUpdateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SharePreferencesUpdateRequestAction && loginState is LoginSuccessState) {
      store.dispatch(SharePreferencesUpdateLoadingAction(action.favorisShared));
      final result = await _repository.updateSharePreferences(
        loginState.user.id,
        action.favorisShared,
      );
      if (result) {
        store.dispatch(SharePreferencesUpdateSuccessAction(action.favorisShared));
      } else {
        store.dispatch(SharePreferencesUpdateFailureAction(action.favorisShared));
      }
    }
  }
}
