import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:redux/redux.dart';

import '../../analytics/analytics_constants.dart';
import '../actions/named_actions.dart';
import '../states/app_state.dart';

class UserTrackingStructureMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is LoginAction && action.isSuccess()) {
      final structureName = _getStructureName(action.getResultOrThrow().loginMode);
      MatomoTracker.setCustomDimension(AnalyticsCustomDimensions.structureId, structureName);
    }
  }

  String _getStructureName(LoginMode loginMode) {
    switch (loginMode) {
      case LoginMode.MILO:
        return "Mission Locale";
      case LoginMode.POLE_EMPLOI:
        return "Pôle emploi";
      case LoginMode.PASS_EMPLOI:
        return "pass emploi";
    }
  }
}
