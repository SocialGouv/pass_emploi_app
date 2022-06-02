import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheMiddleware extends MiddlewareClass<AppState> {
  final CreateDemarcheRepository _repository;

  CreateDemarcheMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is CreateDemarcheRequestAction) {
      final result = _repository.createDemarche(action.commentaire, action.dateEcheance);
      if (result) {
        store.dispatch(CreateDemarcheSuccessAction());
      } else {
        store.dispatch(CreateDemarcheFailureAction());
      }
    }
  }
}

class CreateDemarcheRepository {
  bool createDemarche(String commentaire, DateTime dateEcheance) {
    return true;
  }
}
