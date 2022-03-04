import 'package:pass_emploi_app/redux/actions/immersion_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:redux/redux.dart';

class ImmersionFiltresMiddleware extends MiddlewareClass<AppState> {
  final ImmersionRepository _repository;

  ImmersionFiltresMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    final loginState = store.state.loginState;
    final parametersState = store.state.immersionSearchParametersState;
    final immersionSearchState = store.state.immersionSearchState;
    if (loginState.isSuccess()) {
      final userId = loginState.getResultOrThrow().id;
      if (action is ImmersionSearchUpdateFiltresAction &&
          parametersState is ImmersionSearchParametersInitializedState) {
        _resetSearchWithUpdatedFiltres(
          store: store,
          userId: userId,
          request: SearchImmersionRequest(
            filtres: action.updatedFiltres,
            location: parametersState.location,
            codeRome: parametersState.codeRome,
          ),
        );
      }
    }
  }

  Future<void> _resetSearchWithUpdatedFiltres({
    required Store<AppState> store,
    required String userId,
    required SearchImmersionRequest request,
  }) async {
    store.dispatch(ImmersionAction.loading());
    final result = await _repository.search(userId: userId, request: request);
    if (result != null) {
      store.dispatch(ImmersionSearchWithUpdateFiltresSuccessAction(immersions: result));
    } else {
      store.dispatch(ImmersionSearchWithUpdateFiltresFailureAction());
    }
  }
}
