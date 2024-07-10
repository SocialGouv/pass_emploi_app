import 'package:intl/intl.dart';
import 'package:pass_emploi_app/collection/first_in_first_out_queue.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CrashlyticsMiddleware extends MiddlewareClass<AppState> {
  static const _CAPACITY = 20;
  final _formatter = DateFormat("HH':'mm':'ss'.'SSS");
  final _lastActions = FirstInFirstOutQueue<String>(_CAPACITY);

  final Crashlytics crashlytics;

  CrashlyticsMiddleware(this.crashlytics);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is LoginSuccessAction) crashlytics.setUserIdentifier(action.user.id);

    _lastActions.add(_actionToString(action));
    crashlytics.setCustomKey("last_actions", _formatQueueForCrashlytics());
    crashlytics.setCustomKey("app_state", _formatStoreForCrashlytics(store));

    next(action);
  }

  String _actionToString(dynamic action) {
    return "${action.toString().replaceAll('Instance of ', '')}(${_formatter.format(DateTime.now())})";
  }

  String _formatQueueForCrashlytics() {
    return _lastActions.toList().toString();
  }

  String _formatStoreForCrashlytics(Store<AppState> store) => store.state.toString().replaceAll('Instance of ', '');
}
