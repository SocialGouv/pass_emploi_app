import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/modify_demarche_repository.dart';
import 'package:redux/redux.dart';

class ModifyDemarcheMiddleware extends MiddlewareClass<AppState> {
  final ModifyDemarcheRepository _repository;

  ModifyDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is ModifyDemarcheStatusAction) {
      final modifiedDemarche = await _repository.modifyDemarche(
        loginState.user.id,
        action.id,
        action.status,
        action.dateFin,
        action.dateDebut,
      );
      final demarcheListState = store.state.demarcheListState;
      if (modifiedDemarche != null && demarcheListState is DemarcheListSuccessState) {
        final currentDemarches = demarcheListState.userActions.toList();
        final indexOfCurrentDemarche = currentDemarches.indexWhere((e) => e.id == action.id);
        currentDemarches[indexOfCurrentDemarche] = modifiedDemarche;
        store.dispatch(DemarcheSuccessUpdateAction(currentDemarches));
      }
    }
  }
}
