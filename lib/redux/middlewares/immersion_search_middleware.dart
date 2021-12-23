import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/requests/Immersion_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/Immersion_repository.dart';
import 'package:redux/redux.dart';

class ImmersionSearchMiddleware extends MiddlewareClass<AppState> {
  final ImmersionRepository _repository;

  ImmersionSearchMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestAction<ImmersionRequest, List<Immersion>>) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        store.dispatch(LoadingAction<ImmersionRequest, List<Immersion>>());
        final immersions = await _repository.getImmersions(
          userId: loginState.user.id,
          codeRome: action.request.codeRome,
          location: action.request.location,
        );
        store.dispatch(
          immersions != null
              ? SuccessAction<ImmersionRequest, List<Immersion>>(immersions)
              : FailureAction<ImmersionRequest, List<Immersion>>(),
        );
      }
    }
  }
}
