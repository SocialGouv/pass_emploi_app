import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_actions.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:redux/redux.dart';

class PartageActiviteMiddleware extends MiddlewareClass<AppState> {
  final PartageActiviteRepository _repository;

  PartageActiviteMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is PartageActiviteRequestAction && loginState is LoginSuccessState) {
      store.dispatch(PartageActiviteLoadingAction());
      final PartageActivite? result = await _repository.getPartageActivite(loginState.user.id);
      if (result != null) {
        store.dispatch(PartageActiviteSuccessAction(result));
      } else {
        store.dispatch(PartageActiviteFailureAction());
      }
    }
  }
}
