import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/service_civique_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueSavedSearchBottomSheet extends AbstractSavedSearchBottomSheet<ServiceCiviqueSavedSearch> {
  ServiceCiviqueSavedSearchBottomSheet() : super(analyticsScreenName: AnalyticsScreenNames.serviceCiviqueCreateAlert);

  @override
  ServiceCiviqueSavedSearchViewModel converter(Store<AppState> store) {
    return SavedSearchViewModel.createForServiceCivique(store);
  }

  @override
  Widget buildSaveSearch(BuildContext context, ServiceCiviqueSavedSearchViewModel itemViewModel) {
    return _buildForm(context, itemViewModel);
  }

  Widget _buildForm(BuildContext context, ServiceCiviqueSavedSearchViewModel viewModel) {
    return BottomSheetWrapper(
      body: ServiceCiviqueBottomSheetForm(viewModel),
      title: Strings.savedSearchTitle,
    );
  }

  @override
  void dismissBottomSheetIfNeeded(BuildContext context, ServiceCiviqueSavedSearchViewModel newVm) {
    if (newVm.displayState == CreateSavedSearchDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      showSuccessfulSnackBar(context, Strings.savedSearchSuccessfullyCreated);
    }
  }
}
