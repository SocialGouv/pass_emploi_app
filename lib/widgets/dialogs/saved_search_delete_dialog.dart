import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_delete_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

enum SavedSearchType { EMPLOI, ALTERNANCE, IMMERSION, SERVICE_CIVIQUE }

class SavedSearchDeleteDialog extends StatelessWidget {
  final String savedSearchId;
  final SavedSearchType type;

  SavedSearchDeleteDialog(this.savedSearchId, this.type, {Key? key}) : super(key: key);

  static String _screenName(SavedSearchType type) {
    switch (type) {
      case SavedSearchType.EMPLOI:
        return AnalyticsScreenNames.savedSearchEmploiDelete;
      case SavedSearchType.ALTERNANCE:
        return AnalyticsScreenNames.savedSearchAlternanceDelete;
      case SavedSearchType.IMMERSION:
        return AnalyticsScreenNames.savedSearchImmersionDelete;
      case SavedSearchType.SERVICE_CIVIQUE:
        return AnalyticsScreenNames.savedSearchServiceCiviqueDelete;
    }
  }

  static String _actionName(SavedSearchType type) {
    switch (type) {
      case SavedSearchType.EMPLOI:
        return AnalyticsActionNames.deleteSavedSearchEmploi;
      case SavedSearchType.ALTERNANCE:
        return AnalyticsActionNames.deleteSavedSearchAlternance;
      case SavedSearchType.IMMERSION:
        return AnalyticsActionNames.deleteSavedSearchImmersion;
      case SavedSearchType.SERVICE_CIVIQUE:
        return AnalyticsActionNames.deleteSavedSearchServiceCivique;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: _screenName(type),
      child: StoreConnector<AppState, SavedSearchDeleteViewModel>(
        converter: (store) => SavedSearchDeleteViewModel.create(store),
        builder: (context, viewModel) => _alertDialog(context, viewModel),
        onWillChange: (_, viewModel) {
          if (viewModel.displayState == SavedSearchDeleteDisplayState.SUCCESS) {
            MatomoTracker.instance.trackScreenWithName(widgetName: _screenName(type), eventName: _actionName(type));
            Navigator.pop(context, true);
          }
        },
        distinct: true,
        onDispose: (store) => store.dispatch(SavedSearchDeleteResetAction()),
      ),
    );
  }

  Widget _alertDialog(BuildContext context, SavedSearchDeleteViewModel viewModel) {
    return AlertDialog(
      title: Column(
        children: [
          SvgPicture.asset(Drawables.icTrashAlert),
          Text(Strings.savedSearchDeleteMessage, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
          if (_isLoading(viewModel)) _loader(),
          if (viewModel.displayState == SavedSearchDeleteDisplayState.FAILURE) _error(),
        ],
      ),
      actions: [
        SecondaryButton(
          label: Strings.cancelLabel,
          fontSize: FontSizes.medium,
          onPressed: () => Navigator.pop(context),
        ),
        PrimaryActionButton(
          label: Strings.suppressionLabel,
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningLighten,
          disabledBackgroundColor: AppColors.warningLight,
          rippleColor: AppColors.warningLight,
          withShadow: false,
          heightPadding: Margins.spacing_s,
          onPressed: _isLoading(viewModel) ? null : () => viewModel.onDeleteConfirm(savedSearchId),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Margins.spacing_m)),
      actionsPadding: EdgeInsets.only(bottom: Margins.spacing_base),
    );
  }

  bool _isLoading(SavedSearchDeleteViewModel vm) => vm.displayState == SavedSearchDeleteDisplayState.LOADING;

  Widget _error() {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_s),
      child: Text(
        Strings.savedSearchDeleteError,
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
