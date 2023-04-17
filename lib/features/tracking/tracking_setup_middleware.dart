import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class TrackingSetupMiddleware extends MiddlewareClass<AppState> {
  final PassEmploiMatomoTracker _tracker;

  TrackingSetupMiddleware(this._tracker);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is BootstrapAction) {
      _tracker.setDimension(AnalyticsCustomDimensions.userTypeId, AnalyticsCustomDimensions.appUserType);
      final brand = store.state.configurationState.getBrand();
      _tracker.setDimension(AnalyticsCustomDimensions.brandId, brand.isCej ? 'CEJ' : 'BRSA');
    }
    if (action is LoginSuccessAction) {
      _tracker.setDimension(AnalyticsCustomDimensions.structureId, _getStructureName(action.user.loginMode));
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
      case LoginMode.DEMO_PE:
      case LoginMode.DEMO_MILO:
        return "Mode demo";
    }
  }
}
