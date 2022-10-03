import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:redux/redux.dart';

class AccepterSuggestionRechercheMiddleware extends MiddlewareClass<AppState> {
  final SuggestionsRechercheRepository _repository;

  AccepterSuggestionRechercheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;

    if (action is AccepterSuggestionRechercheRequestAction) {
      store.dispatch(AccepterSuggestionRechercheLoadingAction());
      final success = await _repository.accepterSuggestion(userId: userId, suggestionId: action.suggestion.id);
      if (success) {
        store.dispatch(AccepterSuggestionRechercheSuccessAction(action.suggestion));
      } else {
        store.dispatch(AccepterSuggestionRechercheFailureAction());
      }
    }
  }
}
