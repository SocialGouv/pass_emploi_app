import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchMiddleware<T> extends MiddlewareClass<AppState> {
  final SavedSearchRepository<T> _repository;

  SavedSearchMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is RequestPostSavedSearchAction<T> && loginState.isSuccess()) {
        // await _addFavori(store, action, loginState.getResultOrThrow().id);
    }
  }

  // Future<void> _addFavori(
  //     Store<AppState> store,
  //     RequestPostSavedSearchAction<T> action,
  //     String userId,
  //     ) async {
  //   final result = await _repository.postSavedSearch(
  //     userId,
  //     _dataFromIdExtractor.extractFromId(store, action.favoriId),
  //   );
  //   if (result) {
  //     store.dispatch(SavedSearchSuccessAction<T>());
  //   } else {
  //     store.dispatch(SavedSearchFailureAction<T>());
  //   }
  // }
}

abstract class DataFromIdExtractor<T> {
  T extractFromId(Store<AppState> store, String favoriId);
}
