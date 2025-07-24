import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/boulanger_campagne/boulanger_campagne_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/boulanger_campagne_repository.dart';
import 'package:redux/redux.dart';

class BoulangerCampagneMiddleware extends MiddlewareClass<AppState> {
  final BoulangerCampagneRepository _repository;

  BoulangerCampagneMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      final result = await _repository.get();
      store.dispatch(BoulangerCampagneSuccessAction(result));
    } else if (action is BoulangerCampagneHideAction) {
      await _repository.save();
      store.dispatch(BoulangerCampagneSuccessAction(false));
    }
  }
}
