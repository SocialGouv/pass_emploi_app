import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/alerte_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/service_civique_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueAlerteBottomSheet extends AbstractAlerteBottomSheet<ServiceCiviqueAlerte> {
  ServiceCiviqueAlerteBottomSheet() : super(analyticsScreenName: AnalyticsScreenNames.serviceCiviqueCreateAlert);

  @override
  ServiceCiviqueAlerteViewModel converter(Store<AppState> store) {
    return AlerteViewModel.createForServiceCivique(store);
  }

  @override
  Widget buildSaveSearch(BuildContext context, ServiceCiviqueAlerteViewModel itemViewModel) {
    return _buildForm(context, itemViewModel);
  }

  Widget _buildForm(BuildContext context, ServiceCiviqueAlerteViewModel viewModel) {
    return BottomSheetWrapper(
      body: ServiceCiviqueBottomSheetForm(viewModel),
      title: Strings.createAlerteTitle,
    );
  }

  @override
  void dismissBottomSheetIfNeeded(BuildContext context, ServiceCiviqueAlerteViewModel newVm) {
    if (newVm.displayState == CreateAlerteDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      showSnackBarWithSuccess(context, Strings.alerteSuccessfullyCreated);
    }
  }
}
