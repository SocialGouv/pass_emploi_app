import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_delete_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

enum AlerteType { EMPLOI, ALTERNANCE, IMMERSION, SERVICE_CIVIQUE }

class AlerteDeleteDialog extends StatelessWidget {
  final String alerteId;
  final AlerteType type;

  AlerteDeleteDialog(this.alerteId, this.type, {super.key});

  static String _screenName(AlerteType type) {
    switch (type) {
      case AlerteType.EMPLOI:
        return AnalyticsScreenNames.alerteEmploiDelete;
      case AlerteType.ALTERNANCE:
        return AnalyticsScreenNames.alerteAlternanceDelete;
      case AlerteType.IMMERSION:
        return AnalyticsScreenNames.alerteImmersionDelete;
      case AlerteType.SERVICE_CIVIQUE:
        return AnalyticsScreenNames.alerteServiceCiviqueDelete;
    }
  }

  static String _actionName(AlerteType type) {
    switch (type) {
      case AlerteType.EMPLOI:
        return AnalyticsActionNames.deleteAlerteEmploi;
      case AlerteType.ALTERNANCE:
        return AnalyticsActionNames.deleteAlerteAlternance;
      case AlerteType.IMMERSION:
        return AnalyticsActionNames.deleteAlerteImmersion;
      case AlerteType.SERVICE_CIVIQUE:
        return AnalyticsActionNames.deleteAlerteServiceCivique;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: _screenName(type),
      child: StoreConnector<AppState, AlerteDeleteViewModel>(
        converter: (store) => AlerteDeleteViewModel.create(store),
        builder: (context, viewModel) => _alertDialog(context, viewModel),
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

  Widget _alertDialog(BuildContext context, AlerteDeleteViewModel viewModel) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: Margins.spacing_m),
              SizedBox.square(
                dimension: 120,
                child: Illustration.red(AppIcons.delete),
              ),
              SizedBox(height: Margins.spacing_m),
              Text(Strings.alerteDeleteMessageTitle, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
              SizedBox(height: Margins.spacing_m),
              Text(Strings.alerteDeleteMessageSubtitle, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
              if (_isLoading(viewModel)) _loader(),
              if (viewModel.displayState == AlerteDeleteDisplayState.FAILURE) _error(),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.nightBlue),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
      actions: [
        SecondaryButton(
          label: Strings.cancelLabel,
          fontSize: FontSizes.medium,
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: Margins.spacing_s),
        PrimaryActionButton(
          label: Strings.suppressionLabel,
          onPressed: _isLoading(viewModel) ? null : () => viewModel.onDeleteConfirm(alerteId),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Margins.spacing_m)),
      actionsPadding: EdgeInsets.only(bottom: Margins.spacing_base),
    );
  }

  bool _isLoading(AlerteDeleteViewModel vm) => vm.displayState == AlerteDeleteDisplayState.LOADING;

  Widget _error() {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_s),
      child: Text(
        Strings.alerteDeleteError,
        textAlign: TextAlign.center,
        style: TextStyles.textSRegular(color: AppColors.warning),
      ),
    );
  }

  Widget _loader() {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_s),
      child: SizedBox(
        height: Margins.spacing_m,
        width: Margins.spacing_m,
        child: CircularProgressIndicator(color: AppColors.nightBlue, strokeWidth: 2),
      ),
    );
  }
}
