import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:redux/redux.dart';

class DemarcheListMiddleware extends MiddlewareClass<AppState> {
  final PageDemarcheRepository _repository;

  DemarcheListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState &&
        (action is DemarcheListRequestAction || action is CreateDemarcheSuccessAction)) {
      store.dispatch(DemarcheListLoadingAction());
      final page = await _repository.getPageDemarches(loginState.user.id);
      store.dispatch(page != null ? DemarcheListSuccessAction(page.demarches) : DemarcheListFailureAction());
      store.dispatch(CampagneFetchedAction(page?.campagne));
    }
  }
}
