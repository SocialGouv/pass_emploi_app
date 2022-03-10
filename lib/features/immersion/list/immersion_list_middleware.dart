import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:redux/redux.dart';

class ImmersionListMiddleware extends MiddlewareClass<AppState> {
  final ImmersionRepository _repository;

  ImmersionListMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      if (action is ImmersionListRequestAction) {
        store.dispatch(ImmersionListLoadingAction());
        final immersions = await _repository.search(
          userId: loginState.user.id,
          request: SearchImmersionRequest(
            codeRome: action.request.codeRome,
            location: action.request.location,
            filtres: ImmersionSearchParametersFiltres.noFiltres(),
          ),
        );
        store.dispatch(immersions != null ? ImmersionListSuccessAction(immersions) : ImmersionListFailureAction());
      } else if (action is ImmersionSearchWithFiltresAction) {
        store.dispatch(ImmersionListLoadingAction());
        final immersions = await _repository.search(
          userId: loginState.user.id,
          request: SearchImmersionRequest(
            codeRome: action.request.codeRome,
            location: action.request.location,
            filtres: action.filtres,
          ),
        );
        store.dispatch(immersions != null ? ImmersionListSuccessAction(immersions) : ImmersionListFailureAction());
      }
    }
  }
}
