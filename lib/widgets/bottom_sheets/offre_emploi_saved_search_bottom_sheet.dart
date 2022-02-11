import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/saved_search_bottom_sheet.dart';
import 'package:redux/redux.dart';

import '../../ui/strings.dart';
import '../snack_bar/show_snack_bar.dart';

class OffreEmploiSavedSearchBottomSheet extends AbstractSavedSearchBottomSheet<OffreEmploiSavedSearch> {
  final bool onlyAlternance;

  OffreEmploiSavedSearchBottomSheet({required this.onlyAlternance})
      : super(
          analyticsScreenName:
              onlyAlternance ? AnalyticsScreenNames.alternanceCreateAlert : AnalyticsScreenNames.emploiCreateAlert,
          key: ValueKey(onlyAlternance),
        );

  @override
  SavedSearchViewModel<OffreEmploiSavedSearch> converter(Store<AppState> store) {
    return SavedSearchViewModel.createForOffreEmploi(store, onlyAlternance: onlyAlternance);
  }

  @override
  Widget buildSaveSearch(BuildContext context, OffreEmploiSavedSearchViewModel viewModel) {
    return _buildForm(context, viewModel);
  }

  Widget _buildForm(BuildContext context, OffreEmploiSavedSearchViewModel viewModel) {
    return FractionallySizedBox(
      heightFactor: 0.90,
      child: OffreEmploiBottomSheetForm(viewModel, onlyAlternance),
    );
  }

  @override
  dismissBottomSheetIfNeeded(BuildContext context, OffreEmploiSavedSearchViewModel viewModel) {
    if (viewModel.displayState == CreateSavedSearchDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      (viewModel.savingFailure())
          ? showSnackBarError(context, Strings.creationSavedSearchError)
          : showSuccessfulSnackBar(context, Strings.savedSearchSuccessfullyCreated);
    }
    if (viewModel.savingFailure()) showSnackBarError(context, Strings.creationSavedSearchError);
  }
}
