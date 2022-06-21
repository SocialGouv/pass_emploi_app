import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:redux/redux.dart';

class SearchDemarcheMiddleware extends MiddlewareClass<AppState> {
  final SearchDemarcheRepository _repository;

  SearchDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is SearchDemarcheRequestAction) {
      store.dispatch(SearchDemarcheLoadingAction());
      final demarches = await _repository.search(action.query);
      store.dispatch(demarches != null ? SearchDemarcheSuccessAction(demarches) : SearchDemarcheFailureAction());
    }
  }
}
