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
      final result = await _repository.modifyDemarche(loginState.user.id, action.id, action.status, action.dateDebut);
      final demarcheListState = store.state.userActionPEListState;
      if (result == true && demarcheListState is UserActionPEListSuccessState) {
        final actionToModified = demarcheListState.userActions.firstWhere((element) => element.id == action.id);
        final index = demarcheListState.userActions.indexWhere((e) => e.id == action.id);
        demarcheListState.userActions[index] = actionToModified.copyWithStatus(action.status);
        store.dispatch(DemarcheSuccessfullyModifiedAction(demarcheListState.userActions));
      }
    }
  }
}
