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
      for (var action in action.actions) {
        final result = await _repository.createDemarche(
          userId: userId,
          codeQuoi: action.codeQuoi,
          codePourquoi: action.codePourquoi,
          codeComment: action.codeComment,
          dateEcheance: action.dateEcheance,
          estDuplicata: action.estDuplicata,
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
