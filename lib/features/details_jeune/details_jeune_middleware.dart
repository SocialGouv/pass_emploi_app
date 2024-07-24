import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:redux/redux.dart';

class DetailsJeuneMiddleware extends MiddlewareClass<AppState> {
  final DetailsJeuneRepository _repository;

  DetailsJeuneMiddleware(this._repository);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is DetailsJeuneRequestAction) await _handleRequestAction(store);
  }

  Future<void> _handleRequestAction(Store<AppState> store) async {
    final loginState = store.state.loginState;
    if (loginState is! LoginSuccessState) return;

    store.dispatch(DetailsJeuneLoadingAction());
    final result = await _repository.get(loginState.user.id);

    if (result != null) {
      store.dispatch(DetailsJeuneSuccessAction(detailsJeune: result));
    } else {
      store.dispatch(DetailsJeuneFailureAction());
    }
  }
}