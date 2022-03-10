import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
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
    if (loginState is LoginSuccessState) {
      final userId = loginState.user.id;
      if (action is ImmersionSearchUpdateFiltresRequestAction &&
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
    store.dispatch(ImmersionListLoadingAction());
    final result = await _repository.search(userId: userId, request: request);
    if (result != null) {
      store.dispatch(ImmersionSearchWithUpdateFiltresSuccessAction(immersions: result));
    } else {
      store.dispatch(ImmersionSearchWithUpdateFiltresFailureAction());
    }
  }
}
