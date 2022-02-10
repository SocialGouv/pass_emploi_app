import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/saved_search_bottom_sheet.dart';
import 'package:redux/redux.dart';

import '../../ui/strings.dart';
import '../immersion_bottom_sheet_form.dart';
import '../snack_bar/show_snack_bar.dart';

class ImmersionSavedSearchBottomSheet extends AbstractSavedSearchBottomSheet<ImmersionSavedSearch> {
  final _formKey = GlobalKey<FormState>();

  ImmersionSavedSearchBottomSheet()
      : super(
          selectState: (store) => store.state.immersionSavedSearchState,
          analyticsScreenName: AnalyticsScreenNames.immersionCreateAlert,
        );

  @override
  ImmersionSavedSearchViewModel converter(Store<AppState> store) {
    return SavedSearchViewModel.createForImmersion(store);
  }

  @override
  Widget buildSaveSearch(BuildContext context, ImmersionSavedSearchViewModel viewModel) {
    return _buildForm(context, viewModel);
  }

  Form _buildForm(BuildContext context, ImmersionSavedSearchViewModel viewModel) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: FractionallySizedBox(
        heightFactor: 0.90,
        child: ImmersionBottomSheetForm(viewModel),
      ),
    );
  }

  @override
  dismissBottomSheetIfNeeded(BuildContext context, ImmersionSavedSearchViewModel viewModel) {
    if (viewModel.displayState == CreateSavedSearchDisplayState.TO_DISMISS) {
      Navigator.pop(context);
      (viewModel.savingFailure())
          ? showSnackBarError(context, Strings.creationSavedSearchError)
          : showSuccessfulSnackBar(context, Strings.savedSearchSuccessfullyCreated);
    }
  }
}
