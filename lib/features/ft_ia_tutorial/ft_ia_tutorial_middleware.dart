import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:redux/redux.dart';

class FtIaTutorialMiddleware extends MiddlewareClass<AppState> {
  final TutorialRepository _repository;

  FtIaTutorialMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is MonSuiviRequestAction) {
      final result = await _repository.shouldShowFtIaTutorial();
      store.dispatch(FtIaTutorialSuccessAction(result));
    }
    if (action is FtIaTutorialSeenAction) {
      await _repository.setFtIaTutorialSeen();
      store.dispatch(FtIaTutorialSuccessAction(false));
    }
  }
}
