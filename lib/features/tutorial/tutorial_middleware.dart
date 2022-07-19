import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/models/tutorial_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:redux/redux.dart';

class TutorialMiddleware extends MiddlewareClass<AppState> {
  final TutorialRepository _repository;

  TutorialMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    List<TutorialPage> pages = [];
    next(action);
    if (action is LoginSuccessAction || action is TutorialRequestAction) {
      final loginState = store.state.loginState;
      if (loginState is LoginSuccessState) {
        final loginMode = loginState.user.loginMode;
        // todo: 810 Mode Demo ?
        //if (loginMode == LoginMode.DEMO_MILO && loginMode == LoginMode.DEMO_PE)
        if (loginMode == LoginMode.PASS_EMPLOI) pages = await _repository.getPoleEmploiTutorial();
        if (loginMode == LoginMode.MILO) pages = await _repository.getMiloTutorial();
        if (loginMode == LoginMode.POLE_EMPLOI) pages = await _repository.getMiloTutorial();
        if (pages.isNotEmpty) store.dispatch(TutorialSuccessAction(pages));
      }
    }
  }
}
