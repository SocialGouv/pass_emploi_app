import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/ia_ft_suggestions_repository.dart';
import 'package:redux/redux.dart';

class IaFtSuggestionsMiddleware extends MiddlewareClass<AppState> {
  final IaFtSuggestionsRepository _repository;

  IaFtSuggestionsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is IaFtSuggestionsRequestAction) {
      store.dispatch(IaFtSuggestionsLoadingAction());
      final result = await _repository.get(action.query);
      if (result != null) {
        store.dispatch(IaFtSuggestionsSuccessAction(result));
      } else {
        store.dispatch(IaFtSuggestionsFailureAction());
      }
    }
  }
}
