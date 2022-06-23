import 'dart:async';

import 'package:logging/logging.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class MatomoLoggingMiddleware extends MiddlewareClass<AppState> {
  StreamSubscription<LogRecord>? _subscription;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (_shouldActivateMatomoLogging(store, action)) {
      _enableMatomoLogger();
      _subscribeToMatomoLogger(store);
    }
  }

  bool _shouldActivateMatomoLogging(Store<AppState> store, dynamic action) {
    final flavor = store.state.configurationState.getFlavor();
    return flavor == Flavor.STAGING && action is BootstrapAction && _subscription == null;
  }

  void _enableMatomoLogger() {
    hierarchicalLoggingEnabled = true;
    MatomoTracker().log.level = Level.ALL;
  }

  void _subscribeToMatomoLogger(Store<AppState> store) {
    _subscription = MatomoTracker().log.onRecord.listen((event) {
      final trackingEvent = _getEventFromMessage(event.message);
      if (trackingEvent != null) store.dispatch(MatomoLoggingAction(trackingEvent));
    });
  }

  String? _getEventFromMessage(String message) {
    if (message.startsWith(' -> ')) {
      final url = message.replaceFirst(' -> ', '');
      try {
        final uri = Uri.parse(url);
        return uri.queryParameters['action_name'];
      } catch (_) {}
    }
    return null;
  }
}
