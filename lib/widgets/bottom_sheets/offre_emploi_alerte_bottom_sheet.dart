import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/alerte_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class OffreEmploiAlerteBottomSheet extends AbstractAlerteBottomSheet<OffreEmploiAlerte> {
  final bool onlyAlternance;

  OffreEmploiAlerteBottomSheet({required this.onlyAlternance})
      : super(
          analyticsScreenName:
              onlyAlternance ? AnalyticsScreenNames.alternanceCreateAlert : AnalyticsScreenNames.emploiCreateAlert,
          key: ValueKey(onlyAlternance),
        );

  @override
  AlerteViewModel<OffreEmploiAlerte> converter(Store<AppState> store) {
    return AlerteViewModel.createForOffreEmploi(store, onlyAlternance: onlyAlternance);
  }

  @override
  Widget buildSaveSearch(BuildContext context, OffreEmploiAlerteViewModel itemViewModel) {
    return _buildForm(context, itemViewModel);
  }

  Widget _buildForm(BuildContext context, OffreEmploiAlerteViewModel viewModel) {
    return BottomSheetWrapper(
      title: Strings.createAlerteTitle,
      body: OffreEmploiBottomSheetForm(viewModel, onlyAlternance),
    );
  }

  @override
  void dismissBottomSheetIfNeeded(BuildContext context, OffreEmploiAlerteViewModel newVm) {
    if (newVm.displayState == CreateAlerteDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      showSnackBarWithSuccess(context, Strings.alerteSuccessfullyCreated);
    }
  }
}
