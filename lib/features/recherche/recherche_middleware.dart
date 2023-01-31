import 'dart:math';

import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheMiddleware<Request, Result> extends MiddlewareClass<AppState> {
  RechercheMiddleware();

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is RechercheRequestAction) {
      final List<Result>? result = Random().nextBool() ? [] : null;
      final canLoadMore = Random().nextBool();
      if (result != null) {
        store.dispatch(RechercheSuccessAction(result, canLoadMore));
      } else {
        store.dispatch(RechercheFailureAction());
      }
    }
  }
}
