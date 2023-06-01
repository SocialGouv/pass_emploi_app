import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi_details_repository.dart';
import 'package:redux/redux.dart';

class EvenementEmploiDetailsMiddleware extends MiddlewareClass<AppState> {
  final EvenementEmploiDetailsRepository _repository;

  EvenementEmploiDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is EvenementEmploiDetailsRequestAction) {
      store.dispatch(EvenementEmploiDetailsLoadingAction());
      final details = await _repository.get(action.eventId);
      if (details != null) {
        store.dispatch(EvenementEmploiDetailsSuccessAction(details));
      } else {
        store.dispatch(EvenementEmploiDetailsFailureAction());
      }
    }
  }
}
