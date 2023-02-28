import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:redux/redux.dart';

class DiagorienteUrlsMiddleware extends MiddlewareClass<AppState> {
  final DiagorienteUrlsRepository _repository;

  DiagorienteUrlsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is DiagorienteUrlsRequestAction) {
      store.dispatch(DiagorienteUrlsLoadingAction());
      final result = await _repository.getUrls(userId);
      if (result != null) {
        store.dispatch(DiagorienteUrlsSuccessAction(result));
      } else {
        store.dispatch(DiagorienteUrlsFailureAction());
      }
    }
  }
}
