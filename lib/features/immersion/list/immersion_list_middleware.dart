import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
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
    if (loginState is LoginSuccessState && action is ImmersionListRequestAction) {
      store.dispatch(ImmersionListLoadingAction());
      final immersions = await _repository.getImmersions(loginState.user.id, action.request);
      store.dispatch(immersions != null ? ImmersionListSuccessAction(immersions) : ImmersionListFailureAction());
    }
  }
}
