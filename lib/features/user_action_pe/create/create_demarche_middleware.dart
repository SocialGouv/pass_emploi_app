import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
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
      final success = await _repository.createDemarche(action.commentaire, action.dateEcheance, loginState.user.id);
      store.dispatch(success ? CreateDemarcheSuccessAction() : CreateDemarcheFailureAction());
    }
  }
}
