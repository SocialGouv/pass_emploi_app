import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';
import 'package:redux/redux.dart';

class ContactImmersionMiddleware extends MiddlewareClass<AppState> {
  final ContactImmersionRepository _repository;

  ContactImmersionMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is ContactImmersionRequestAction) {
      store.dispatch(ContactImmersionLoadingAction());
      final result = await _repository.post(action.request);
      if (result != null) {
        store.dispatch(ContactImmersionSuccessAction());
      } else {
        store.dispatch(ContactImmersionFailureAction());
      }
    }
  }
}
