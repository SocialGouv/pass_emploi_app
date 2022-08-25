import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
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
      final modifiedDemarche = await _repository.updateDemarche(
        loginState.user.id,
        action.id,
        action.status,
        action.dateFin,
        action.dateDebut,
      );
      if (modifiedDemarche != null) {
        store.dispatch(UpdateDemarcheSuccessAction());
        final demarcheListState = store.state.demarcheListState;
        if (demarcheListState is DemarcheListSuccessState) {
          final currentDemarches = demarcheListState.demarches.toList();
          final indexOfCurrentDemarche = currentDemarches.indexWhere((e) => e.id == action.id);
          currentDemarches[indexOfCurrentDemarche] = modifiedDemarche;
          store.dispatch(DemarcheListSuccessAction(currentDemarches, true));
        }
      } else {
        store.dispatch(UpdateDemarcheFailureAction());
      }
    }
  }
}
