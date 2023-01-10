import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class MatomoLoggingMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (_shouldActivateMatomoLogging(store, action)) {
      PassEmploiMatomoTracker.instance.onTrackScreen = (screen) => store.dispatch(MatomoLoggingAction(screen));
    }
  }

  bool _shouldActivateMatomoLogging(Store<AppState> store, dynamic action) {
    final flavor = store.state.configurationState.getFlavor();
    return flavor == Flavor.STAGING && action is BootstrapAction;
  }
}
