import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_state.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';
import 'package:synchronized/synchronized.dart';

class UserActionCreatePendingMiddleware extends MiddlewareClass<AppState> {
  final Lock _lock = Lock();
  final UserActionRepository _repository;
  final UserActionPendingCreationRepository _pendingCreationRepository;

  UserActionCreatePendingMiddleware(this._repository, this._pendingCreationRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      store.dispatch(UserActionCreatePendingAction(await _pendingCreationRepository.getPendingActionCount()));
    }
    if (action is UserActionCreateFailureAction) {
      final pendingCreationsCount = await _pendingCreationRepository.save(action.request);
      store.dispatch(UserActionCreatePendingAction(pendingCreationsCount));
    }
    if (action is ConnectivityUpdatedAction && action.results.isOnline()) {
      _lock.synchronized(() => _synchronizePendingUserActions(store));
    }
  }

  Future<void> _synchronizePendingUserActions(Store<AppState> store) async {
    final userId = store.state.userId();
    if (userId == null) return;

    final pendingCreations = await _pendingCreationRepository.load();
    int synchronizedActionsCount = 0;

    for (final pendingCreation in pendingCreations) {
      final result = await _repository.createUserAction(userId, pendingCreation);
      if (result != null) {
        await _pendingCreationRepository.delete(pendingCreation);
        synchronizedActionsCount++;
      }
    }

    if (synchronizedActionsCount != 0) {
      store.dispatch(UserActionCreatePendingAction(pendingCreations.length - synchronizedActionsCount));
    }
  }
}
