import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheResponse<Result> {
  final List<Result> results;
  final bool canLoadMore;

  RechercheResponse({
    required this.results,
    required this.canLoadMore,
  });
}

abstract class RechercheRepository<Request, Result> {
  Future<RechercheResponse<Result>?> recherche({required String userId, required Request request});
}

class RechercheMiddleware<Request, Result> extends MiddlewareClass<AppState> {
  final RechercheRepository<Request, Result> _repository;

  RechercheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is RechercheRequestAction<Request>) {
      final response = await _repository.recherche(userId: userId, request: action.request);
      if (response != null) {
        store.dispatch(RechercheSuccessAction(response.results, response.canLoadMore));
      } else {
        store.dispatch(RechercheFailureAction());
      }
    }
  }
}
