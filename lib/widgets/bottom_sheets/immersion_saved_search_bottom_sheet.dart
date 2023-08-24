import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class ImmersionSavedSearchBottomSheet extends AbstractSavedSearchBottomSheet<ImmersionSavedSearch> {
  ImmersionSavedSearchBottomSheet() : super(analyticsScreenName: AnalyticsScreenNames.immersionCreateAlert);

  @override
  ImmersionSavedSearchViewModel converter(Store<AppState> store) => SavedSearchViewModel.createForImmersion(store);

  @override
  Widget buildSaveSearch(BuildContext context, ImmersionSavedSearchViewModel itemViewModel) {
    return _buildForm(context, itemViewModel);
  }

  Widget _buildForm(BuildContext context, ImmersionSavedSearchViewModel viewModel) {
    return BottomSheetWrapper(
      title: Strings.createSavedSearchTitle,
      body: ImmersionBottomSheetForm(viewModel),
    );
  }

  @override
  void dismissBottomSheetIfNeeded(BuildContext context, ImmersionSavedSearchViewModel newVm) {
    if (newVm.displayState == CreateSavedSearchDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      showSuccessfulSnackBar(context, Strings.savedSearchSuccessfullyCreated);
    }
  }
}
