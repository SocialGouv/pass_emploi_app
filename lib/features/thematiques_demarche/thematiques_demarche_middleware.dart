import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';
import 'package:redux/redux.dart';

class ThematiquesDemarcheMiddleware extends MiddlewareClass<AppState> {
  final ThematiquesDemarcheRepository _repository;

  ThematiquesDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is ThematiquesDemarcheRequestAction) {
      store.dispatch(ThematiquesDemarcheLoadingAction());
      final result = await _repository.get();
      if (result != null) {
        store.dispatch(ThematiquesDemarcheSuccessAction(result));
      } else {
        store.dispatch(ThematiquesDemarcheFailureAction());
      }
    }
  }
}
