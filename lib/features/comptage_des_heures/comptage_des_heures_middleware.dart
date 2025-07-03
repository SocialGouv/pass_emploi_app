import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/comptage_des_heures_repository.dart';
import 'package:redux/redux.dart';

class ComptageDesHeuresMiddleware extends MiddlewareClass<AppState> {
  final ComptageDesHeuresRepository _repository;

  ComptageDesHeuresMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is ComptageDesHeuresRequestAction) {
      if (store.state.comptageDesHeuresState is ComptageDesHeuresSuccessState) return;
      store.dispatch(ComptageDesHeuresLoadingAction());
      final result = await _repository.get(userId: userId);
      if (result != null) {
        store.dispatch(ComptageDesHeuresSuccessAction(result));
      } else {
        store.dispatch(ComptageDesHeuresFailureAction());
      }
    }
  }
}
