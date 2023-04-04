import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:redux/redux.dart';

class AccueilMiddleware extends MiddlewareClass<AppState> {
  final AccueilRepository _repository;

  AccueilMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (action is AccueilRequestAction) {
      store.dispatch(AccueilLoadingAction());
      final result = await getAccueil(user);
      if (result != null) {
        store.dispatch(AccueilSuccessAction(result));
      } else {
        store.dispatch(AccueilFailureAction());
      }
    }
  }

  Future<Accueil?> getAccueil(User user) {
    if (user.loginMode.isPe()) {
      return _repository.getAccueilPoleEmploi(user.id, DateTime.now());
    }
    return _repository.getAccueilMissionLocale(user.id, DateTime.now());
  }
}
