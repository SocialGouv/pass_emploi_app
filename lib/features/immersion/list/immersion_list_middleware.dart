import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:redux/redux.dart';

class ImmersionListMiddleware extends MiddlewareClass<AppState> {
  final ImmersionRepository _repository;

  ImmersionListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    final parametersState = store.state.immersionSearchParametersState;
    if (loginState is LoginSuccessState) {
      if (action is ImmersionListRequestAction) {
        store.dispatch(ImmersionListLoadingAction());
        final immersions = await _repository.search(
          userId: loginState.user.id,
          request: SearchImmersionRequest(
            codeRome: action.codeRome,
            location: action.location,
            filtres: ImmersionFiltresRecherche.noFiltre(),
          ),
        );
        store.dispatch(immersions != null ? ImmersionListSuccessAction(immersions) : ImmersionListFailureAction());
      } else if (action is ImmersionSearchUpdateFiltresRequestAction &&
          parametersState is ImmersionSearchParametersInitializedState) {
        _resetSearchWithUpdatedFiltres(
          store: store,
          userId: loginState.user.id,
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
