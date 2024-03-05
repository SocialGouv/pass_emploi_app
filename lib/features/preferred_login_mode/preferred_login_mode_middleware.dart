import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/preferred_login_mode_repository.dart';
import 'package:redux/redux.dart';

class PreferredLoginModeMiddleware extends MiddlewareClass<AppState> {
  final PreferredLoginModeRepository _repository;

  PreferredLoginModeMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is PreferredLoginModeRequestAction) {
      final result = await _repository.getPreferredMode();
      store.dispatch(PreferredLoginModeSuccessAction(result));
    } else if (action is PreferredLoginModeSaveAction) {
      await _repository.save(action.loginMode);
    }
  }
}
