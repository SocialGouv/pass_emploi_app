import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';
import 'package:redux/redux.dart';

class RecherchesRecentesMiddleware extends MiddlewareClass<AppState> {
  final RecherchesRecentesRepository _repository;

  RecherchesRecentesMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is RecherchesRecentesRequestAction) {
      store.dispatch(RecherchesRecentesLoadingAction());
      final result = await _repository.get();
      if (result != null) {
        store.dispatch(RecherchesRecentesSuccessAction(result));
      } else {
        store.dispatch(RecherchesRecentesFailureAction());
      }
    }
  }
}
