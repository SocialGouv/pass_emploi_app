import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:redux/redux.dart';

class PartageActiviteUpdateMiddleware extends MiddlewareClass<AppState> {
  final PartageActiviteRepository _repository;

  PartageActiviteUpdateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is PartageActiviteUpdateRequestAction && loginState is LoginSuccessState) {
      store.dispatch(PartageActiviteUpdateLoadingAction(action.favorisShared));
      final result = await _repository.updatePartageActivite(
        loginState.user.id,
        action.favorisShared,
      );
      if (result) {
        store.dispatch(PartageActiviteUpdateSuccessAction(action.favorisShared));
      } else {
        store.dispatch(PartageActiviteUpdateFailureAction(action.favorisShared));
      }
    }
  }
}
