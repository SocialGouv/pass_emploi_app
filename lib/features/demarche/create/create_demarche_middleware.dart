import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:redux/redux.dart';

class CreateDemarcheMiddleware extends MiddlewareClass<AppState> {
  final CreateDemarcheRepository _repository;

  CreateDemarcheMiddleware(this._repository);

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is CreateDemarcheRequestAction && loginState is LoginSuccessState) {
      store.dispatch(CreateDemarcheLoadingAction());
      final demarcheId = await _repository.createDemarche(
        userId: loginState.user.id,
        codeQuoi: action.codeQuoi,
        codePourquoi: action.codePourquoi,
        codeComment: action.codeComment,
        dateEcheance: action.dateEcheance,
      );
      _dispatchCreateDemarche(demarcheId, store);
    }
    if (action is CreateDemarchePersonnaliseeRequestAction && loginState is LoginSuccessState) {
      store.dispatch(CreateDemarcheLoadingAction());
      final success = await _repository.createDemarchePersonnalisee(
        userId: loginState.user.id,
        commentaire: action.commentaire,
        dateEcheance: action.dateEcheance,
      );
      _dispatchCreateDemarche(success, store);
    }
  }

  void _dispatchCreateDemarche(String? demarcheId, Store<AppState> store) {
    if (demarcheId != null) {
      store.dispatch(CreateDemarcheSuccessAction(demarcheId));
      store.dispatch(AgendaRequestAction(DateTime.now()));
    } else {
      store.dispatch(CreateDemarcheFailureAction());
    }
  }
}
