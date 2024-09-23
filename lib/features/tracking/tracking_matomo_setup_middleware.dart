import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class TrackingMatomoSetupMiddleware extends MiddlewareClass<AppState> {
  final PassEmploiMatomoTracker _tracker;

  TrackingMatomoSetupMiddleware(this._tracker);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is BootstrapAction) {
      _trackUserType();
    } else if (action is LoginSuccessAction) {
      _trackStructureAndAccompagnement(store, action);
    } else if (action is ConnectivityUpdatedAction) {
      _trackConnexionStatus(store, action);
    }
  }

  void _trackUserType() {
    _tracker.setDimension(AnalyticsCustomDimensions.userTypeId, AnalyticsCustomDimensions.appUserType);
  }

  void _trackStructureAndAccompagnement(Store<AppState> store, LoginSuccessAction action) {
    _tracker.setDimension(AnalyticsCustomDimensions.structureId, action.user.structureName());
    final configuration = store.state.configurationState.configuration;
    if (configuration != null) {
      _tracker.setDimension(configuration.matomoDimensionProduitId, action.user.accompagnementName());
    }
  }

  void _trackConnexionStatus(Store<AppState> store, ConnectivityUpdatedAction action) {
    final configuration = store.state.configurationState.configuration;
    if (configuration != null) {
      final isOnline = action.results.isOnline();
      _tracker.setDimension(configuration.matomoDimensionAvecConnexionId, isOnline.toString());
    }
  }
}

extension on User {
  String structureName() {
    return switch (loginMode) {
      LoginMode.MILO => "Mission Locale",
      LoginMode.POLE_EMPLOI => "Pôle emploi",
      LoginMode.DEMO_PE => "Mode demo",
      LoginMode.DEMO_MILO => "Mode demo",
    };
  }

  String accompagnementName() {
    return switch (accompagnement) {
      Accompagnement.cej => 'CEJ',
      Accompagnement.rsaFranceTravail => 'BRSA', // TODO: CD
      Accompagnement.aij => 'AIJ',
    };
  }
}
