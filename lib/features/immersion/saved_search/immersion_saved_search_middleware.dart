import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:redux/redux.dart';

class ImmersionSavedSearchMiddleware extends MiddlewareClass<AppState> {
  final ImmersionRepository _repository;

  ImmersionSavedSearchMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      if (action is SavedImmersionSearchRequestAction) {
        store.dispatch(ImmersionListLoadingAction());
        final immersions = await _repository.search(
          userId: loginState.user.id,
          request: SearchImmersionRequest(
            codeRome: action.codeRome,
            location: action.location,
            filtres: action.filtres,
          ),
        );
        store.dispatch(immersions != null ? ImmersionListSuccessAction(immersions) : ImmersionListFailureAction());
      }
    }
  }
}
