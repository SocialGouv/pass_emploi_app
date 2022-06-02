import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_pe_repository.dart';
import 'package:redux/redux.dart';

class UserActionPEListMiddleware extends MiddlewareClass<AppState> {
  final PageActionPERepository _repository;
  final FirebaseRemoteConfig? _remoteConfig;

  UserActionPEListMiddleware(this._repository, this._remoteConfig);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && (action is UserActionPEListRequestAction || action is CreateDemarcheSuccessAction)) {
      store.dispatch(UserActionPEListLoadingAction());
      final page = await _repository.getPageActionsPE(loginState.user.id);
      store.dispatch(page != null
          ? UserActionPEListSuccessAction(page.actions, await _isDetailAvailable())
          : UserActionPEListFailureAction());
      store.dispatch(CampagneFetchedAction(page?.campagne));
    }
  }

  Future<bool> _isDetailAvailable() async {
    return _remoteConfig?.getBool('afficher_detail_demarche') ?? false;
  }
}
