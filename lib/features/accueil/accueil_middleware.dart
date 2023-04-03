import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:redux/redux.dart';

class AccueilMiddleware extends MiddlewareClass<AppState> {
  final AccueilRepository _repository;

  AccueilMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is AccueilRequestAction) {
      store.dispatch(AccueilLoadingAction());
      final result = await _repository.getAccueilMissionLocale(userId, DateTime.now());
      //TODO: Milo & PE
      if (result != null) {
        store.dispatch(AccueilSuccessAction(result));
      } else {
        store.dispatch(AccueilFailureAction());
      }
    }
  }
}
