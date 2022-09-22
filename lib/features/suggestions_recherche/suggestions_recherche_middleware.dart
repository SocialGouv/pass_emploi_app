import 'package:pass_emploi_app/features/suggestions_recherche/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheMiddleware extends MiddlewareClass<AppState> {
  final SuggestionsRechercheRepository _repository;

  SuggestionsRechercheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;

    if (action is SuggestionsRechercheRequestAction) {
      store.dispatch(SuggestionsRechercheLoadingAction());
      final suggestions = await _repository.getSuggestions(userId);
      if (suggestions != null) {
        store.dispatch(SuggestionsRechercheSuccessAction(suggestions));
      } else {
        store.dispatch(SuggestionsRechercheFailureAction());
      }
    }
  }
}
