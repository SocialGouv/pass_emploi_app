import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:redux/redux.dart';

class UpdateDemarcheMiddleware extends MiddlewareClass<AppState> {
  final UpdateDemarcheRepository _repository;

  UpdateDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UpdateDemarcheRequestAction) {
      store.dispatch(UpdateDemarcheLoadingAction());
      final demarche = await _repository.updateDemarche(
        userId: loginState.user.id,
        demarcheId: action.id,
        status: action.status,
        dateFin: action.dateFin,
        dateDebut: action.dateDebut,
      );
      store.dispatch(demarche != null ? UpdateDemarcheSuccessAction(demarche) : UpdateDemarcheFailureAction());
    }
  }
}
