import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pass_emploi_app/collection/last_in_first_out_queue.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import 'app_reducer.dart';

const _CAPACITY = 10;
final _lastActions = LastInFirstOutQueue<String>(_CAPACITY);

AppState crashlyticsReducerDecorator(AppState currentState, dynamic action) {
  _lastActions.add(action.toString());
  FirebaseCrashlytics.instance.setCustomKey("last_actions", _formatQueueForCrashlytics());
  FirebaseCrashlytics.instance.setCustomKey("app_state", currentState.toString().replaceAll('Instance of ', ''));
  return reducer(currentState, action);
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
