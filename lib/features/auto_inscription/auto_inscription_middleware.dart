import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';
import 'package:redux/redux.dart';

class AutoInscriptionMiddleware extends MiddlewareClass<AppState> {
  final AutoInscriptionRepository _repository;

  AutoInscriptionMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is AutoInscriptionRequestAction) {
      store.dispatch(AutoInscriptionLoadingAction());
      final result = await _repository.set(userId, action.eventId);
      (switch (result) {
        AutoInscriptionSuccess() => store.dispatch(AutoInscriptionSuccessAction()),
        final AutoInscriptionError error => store.dispatch(AutoInscriptionFailureAction(error: error)),
      });
    }
  }
}
