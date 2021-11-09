import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiRepository _repository;

  OffreEmploiMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoggedInState && action is SearchOffreEmploiAction) {
      store.dispatch(OffreEmploiSearchLoadingAction());
      final result = await _repository.search(
          userId: loginState.user.id, keywords: action.keywords, department: action.department);

      if (result != null) {
        store.dispatch(OffreEmploiSearchSuccessAction(result));
      } else {
        store.dispatch(OffreEmploiSearchFailureAction());
      }
    }
  }
}
