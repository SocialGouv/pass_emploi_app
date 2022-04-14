import 'package:pass_emploi_app/collection/last_in_first_out_queue.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CrashlyticsMiddleware extends MiddlewareClass<AppState> {
  static const _CAPACITY = 10;
  final _lastActions = LastInFirstOutQueue<String>(_CAPACITY);

  final Crashlytics crashlytics;

  CrashlyticsMiddleware(this.crashlytics);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is LoginSuccessAction) crashlytics.setUserIdentifier(action.user.id);
    _lastActions.add(action.toString());
    crashlytics.setCustomKey("last_actions", _formatQueueForCrashlytics());
    crashlytics.setCustomKey("app_state", _formatStoreForCrashlytics(store));
    next(action);
  }

  String _formatQueueForCrashlytics() {
    return _lastActions
        .toList()
        .asMap()
        .entries
        .map((entry) => "#${_CAPACITY - entry.key}:${entry.value.replaceAll('Instance of ', '')}")
        .toList()
        .toString();
  }

  String _formatStoreForCrashlytics(Store<AppState> store) => store.state.toString().replaceAll('Instance of ', '');
}
