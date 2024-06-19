import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';
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
    if (action is LoginSuccessAction) {
      final loginState = store.state.loginState;
      if (loginState is LoginSuccessState && await _repository.shouldShowTutorial()) {
        final loginMode = loginState.user.loginMode;
        if (_requestMiloTutorial(loginMode)) pages = _repository.getMiloTutorial();
        if (_requestPoleEmploiTutorial(loginMode)) pages = _repository.getPoleEmploiTutorial();
        if (pages.isNotEmpty) store.dispatch(TutorialSuccessAction(pages));
      }
    }
    if (action is TutorialDoneAction) {
      await _repository.setTutorialRead();
    }
  }

  bool _requestPoleEmploiTutorial(LoginMode loginMode) {
    return [LoginMode.POLE_EMPLOI, LoginMode.DEMO_PE].contains(loginMode);
  }

  bool _requestMiloTutorial(LoginMode loginMode) {
    return [LoginMode.MILO, LoginMode.DEMO_MILO].contains(loginMode);
  }
}
