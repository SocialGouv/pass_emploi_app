import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/actions/immersion_search_actions.dart';
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
    if (action is SearchImmersionAction) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        store.dispatch(LoadingAction<List<Immersion>>());
        final immersions = await _repository.getImmersions(
          userId: loginState.user.id,
          codeRome: action.codeRome,
          location: action.location,
        );
        store.dispatch(
          immersions != null ? SuccessAction<List<Immersion>>(immersions) : FailureAction<List<Immersion>>(),
        );
      }
    }
  }
}
