import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_delete_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/dialogs/base_delete_dialog.dart';

enum AlerteType { EMPLOI, ALTERNANCE, IMMERSION, SERVICE_CIVIQUE }

class AlerteDeleteDialog extends StatelessWidget {
  final String alerteId;
  final AlerteType type;

  AlerteDeleteDialog(this.alerteId, this.type, {super.key});

  static String _screenName(AlerteType type) {
    return switch (type) {
      AlerteType.EMPLOI => AnalyticsScreenNames.alerteEmploiDelete,
      AlerteType.ALTERNANCE => AnalyticsScreenNames.alerteAlternanceDelete,
      AlerteType.IMMERSION => AnalyticsScreenNames.alerteImmersionDelete,
      AlerteType.SERVICE_CIVIQUE => AnalyticsScreenNames.alerteServiceCiviqueDelete
    };
  }

  static String _actionName(AlerteType type) {
    return switch (type) {
      AlerteType.EMPLOI => AnalyticsActionNames.deleteAlerteEmploi,
      AlerteType.ALTERNANCE => AnalyticsActionNames.deleteAlerteAlternance,
      AlerteType.IMMERSION => AnalyticsActionNames.deleteAlerteImmersion,
      AlerteType.SERVICE_CIVIQUE => AnalyticsActionNames.deleteAlerteServiceCivique
    };
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: _screenName(type),
      child: StoreConnector<AppState, AlerteDeleteViewModel>(
        converter: (store) => AlerteDeleteViewModel.create(store),
        builder: (context, vm) {
          return BaseDeleteDialog(
            title: Strings.alerteDeleteMessageTitle,
            subtitle: Strings.alerteDeleteMessageSubtitle,
            onDelete: () => vm.onDeleteConfirm(alerteId),
            withLoading: vm.displayState == AlerteDeleteDisplayState.LOADING,
            withError: vm.displayState == AlerteDeleteDisplayState.FAILURE,
          );
        },
        onWillChange: (_, viewModel) {
          if (viewModel.displayState == AlerteDeleteDisplayState.SUCCESS) {
            PassEmploiMatomoTracker.instance.trackScreen(_actionName(type));
            Navigator.pop(context, true);
          }
        },
        distinct: true,
        onDispose: (store) => store.dispatch(AlerteDeleteResetAction()),
      ),
    );
  }
}
