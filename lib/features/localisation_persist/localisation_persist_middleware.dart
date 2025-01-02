import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/localisation_persist_repository.dart';
import 'package:redux/redux.dart';

class LocalisationPersistMiddleware extends MiddlewareClass<AppState> {
  final LocalisationPersistRepository _repository;

  LocalisationPersistMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final result = await _repository.get();
      store.dispatch(LocalisationPersistSuccessAction(result));
    }

    if (action is LocalisationPersistWriteAction) {
      await _repository.save(action.location);
      store.dispatch(LocalisationPersistSuccessAction(action.location));
    }
  }
}
