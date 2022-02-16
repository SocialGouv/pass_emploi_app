import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_delete_view_model.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

import '../../analytics/analytics_constants.dart';
import '../../redux/states/app_state.dart';
import '../../ui/app_colors.dart';
import '../../ui/drawables.dart';
import '../../ui/margins.dart';
import '../../ui/strings.dart';
import '../../ui/text_styles.dart';

enum SavedSearchType { EMPLOI, ALTERNANCE, IMMERSION }

class SavedSearchDeleteDialog extends TraceableStatelessWidget {
  final String savedSearchId;
  final SavedSearchType type;

  SavedSearchDeleteDialog(this.savedSearchId, this.type, {Key? key}) : super(key: key, name: _screenName(type));

  static String _screenName(SavedSearchType type) {
    switch (type) {
      case SavedSearchType.EMPLOI:
        return AnalyticsScreenNames.savedSearchEmploiDelete;
      case SavedSearchType.ALTERNANCE:
        return AnalyticsScreenNames.savedSearchAlternanceDelete;
      case SavedSearchType.IMMERSION:
        return AnalyticsScreenNames.savedSearchImmersionDelete;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchDeleteViewModel>(
      converter: (store) => SavedSearchDeleteViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
      distinct: true,
      onDispose: (store) => store.dispatch(SavedSearchDeleteResetAction()),
    );
  }

  Widget _body(BuildContext context, SavedSearchDeleteViewModel viewModel) {
    if (viewModel.displayState == SavedSearchDeleteDisplayState.SUCCESS) {
      MatomoTracker.trackScreenWithName(_actionName(type), _screenName(type));
      Navigator.pop(context, true);
      return SizedBox();
    } else {
      return _alertDialog(context, viewModel);
    }
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
          label: Strings.savedSearchDeleteCancel,
          fontSize: FontSizes.medium,
          onPressed: () => Navigator.pop(context),
        ),
        PrimaryActionButton(
          label: Strings.savedSearchDeleteConfirm,
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
