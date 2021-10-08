import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pass_emploi_app/collection/last_in_first_out_queue.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class CrashlyticsMiddleware extends MiddlewareClass<AppState> {
  static const _CAPACITY = 10;
  final _lastActions = LastInFirstOutQueue<String>(_CAPACITY);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) {
    _lastActions.add(action.toString());

    FirebaseCrashlytics.instance.setCustomKey("last_actions", _formatQueueForCrashlytics());
    FirebaseCrashlytics.instance.setCustomKey("app_state", _formatStoreForCrashlytics(store));

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
