import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_action.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_state.dart';

MatomoLoggingState matomoLoggingReducer(MatomoLoggingState current, dynamic action) {
  if (action is MatomoLoggingAction) return MatomoLoggingState([action.log, ...current.logs]);
  return current;
}
