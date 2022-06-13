import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/modify_demarche_repository.dart';
import 'package:redux/redux.dart';

class UserDemarcheModifyMiddleware extends MiddlewareClass<AppState> {
  final ModifyDemarcheRepository _repository;

  UserDemarcheModifyMiddleware(this._repository);

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
      final demarcheListState = store.state.userActionPEListState;
      if (modifiedDemarche != null && demarcheListState is UserActionPEListSuccessState) {
        final currentDemarches = demarcheListState.userActions.toList();
        final indexOfCurrentDemarche = currentDemarches.indexWhere((e) => e.id == action.id);
        currentDemarches[indexOfCurrentDemarche] = modifiedDemarche;
        store.dispatch(UserActionPESuccessUpdateAction(currentDemarches));
      }
    }
  }
}
