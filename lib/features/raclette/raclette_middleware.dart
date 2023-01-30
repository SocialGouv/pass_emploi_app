import 'package:pass_emploi_app/features/raclette/raclette_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/raclette_repository.dart';
import 'package:redux/redux.dart';

class RacletteMiddleware extends MiddlewareClass<AppState> {
  final RacletteRepository _repository;

  RacletteMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is RacletteRequestAction) {
      final result = await _repository.get();
      if (result != null) {
        store.dispatch(RacletteSuccessAction(result));
      } else {
        store.dispatch(RacletteFailureAction());
      }
    }
  }
}
