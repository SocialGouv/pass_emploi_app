import 'package:pass_emploi_app/features/top_demarche/top_demarche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';
import 'package:redux/redux.dart';

class TopDemarcheMiddleware extends MiddlewareClass<AppState> {
  final TopDemarcheRepository _repository;

  TopDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is TopDemarcheRequestAction) {
      final result = _repository.getTopDemarches();
      store.dispatch(TopDemarcheSuccessAction(result));
    }
  }
}
