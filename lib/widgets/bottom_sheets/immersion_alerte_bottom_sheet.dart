import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/alerte_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class ImmersionAlerteBottomSheet extends AbstractAlerteBottomSheet<ImmersionAlerte> {
  ImmersionAlerteBottomSheet() : super(analyticsScreenName: AnalyticsScreenNames.immersionCreateAlert);

  @override
  ImmersionAlerteViewModel converter(Store<AppState> store) => AlerteViewModel.createForImmersion(store);

  @override
  Widget buildSaveSearch(BuildContext context, ImmersionAlerteViewModel itemViewModel) {
    return _buildForm(context, itemViewModel);
  }

  Widget _buildForm(BuildContext context, ImmersionAlerteViewModel viewModel) {
    return BottomSheetWrapper(
      title: Strings.createAlerteTitle,
      body: ImmersionBottomSheetForm(viewModel),
    );
  }

  @override
  void dismissBottomSheetIfNeeded(BuildContext context, ImmersionAlerteViewModel newVm) {
    if (newVm.displayState == CreateAlerteDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      showSnackBarWithSuccess(context, Strings.alerteSuccessfullyCreated);
    }
  }
}
