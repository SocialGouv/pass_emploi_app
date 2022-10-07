import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:redux/redux.dart';

class TraiterSuggestionRechercheMiddleware extends MiddlewareClass<AppState> {
  final SuggestionsRechercheRepository _repository;

  TraiterSuggestionRechercheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;

    if (action is TraiterSuggestionRechercheRequestAction) {
      store.dispatch(TraiterSuggestionRechercheLoadingAction());
      await _traiterSuggestion(action, userId, store);
    }
  }

  Future<void> _traiterSuggestion(TraiterSuggestionRechercheRequestAction action, String userId, Store<AppState> store) async {
    switch (action.type) {
      case TraiterSuggestionType.accepter:
        final savedSearch = await _repository.accepterSuggestion(userId: userId, suggestionId: action.suggestion.id);
        if (savedSearch != null) {
          store.dispatch(AccepterSuggestionRechercheSuccessAction(action.suggestion.id, savedSearch));
        } else {
          store.dispatch(TraiterSuggestionRechercheFailureAction());
        }
        break;
      case TraiterSuggestionType.refuser:
        final success = await _repository.refuserSuggestion(userId: userId, suggestionId: action.suggestion.id);
        if (success) {
          store.dispatch(RefuserSuggestionRechercheSuccessAction(action.suggestion.id));
        } else {
          store.dispatch(TraiterSuggestionRechercheFailureAction());
        }
        break;
    }
  }
}
