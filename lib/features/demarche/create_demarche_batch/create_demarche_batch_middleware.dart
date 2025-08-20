import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:redux/redux.dart';

class CreateDemarcheBatchMiddleware extends MiddlewareClass<AppState> {
  final CreateDemarcheRepository _repository;

  CreateDemarcheBatchMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is CreateDemarcheBatchRequestAction) {
      store.dispatch(CreateDemarcheBatchLoadingAction());
      bool success = true;
      for (var createAction in action.actions) {
        final result = await _repository.createDemarche(
          userId: userId,
          codeQuoi: createAction.codeQuoi,
          codePourquoi: createAction.codePourquoi,
          codeComment: createAction.codeComment,
          dateEcheance: createAction.dateEcheance,
          estDuplicata: createAction.estDuplicata,
          genereParIA: action.genereParIA,
        );
        if (result == null) {
          success = false;
          break;
        }
      }
      if (success) {
        store.dispatch(CreateDemarcheBatchSuccessAction());
      } else {
        store.dispatch(CreateDemarcheBatchFailureAction());
      }
    }
  }
}
