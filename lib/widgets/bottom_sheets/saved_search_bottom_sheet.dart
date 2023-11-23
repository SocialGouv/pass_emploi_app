import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/saved_search/init/saved_search_initialize_action.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class AbstractSavedSearchBottomSheet<SAVED_SEARCH_MODEL> extends StatelessWidget {
  final String analyticsScreenName;

  const AbstractSavedSearchBottomSheet({required this.analyticsScreenName, super.key});

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: analyticsScreenName,
      child: StoreConnector<AppState, SavedSearchViewModel<SAVED_SEARCH_MODEL>>(
        onInit: (store) => store.dispatch(SaveSearchInitializeAction<SAVED_SEARCH_MODEL>()),
        builder: (context, viewModel) => buildSaveSearch(context, viewModel),
        onWillChange: (previousVm, newVm) => dismissBottomSheetIfNeeded(context, newVm),
        converter: converter,
        distinct: true,
      ),
    );
  }

  SavedSearchViewModel<SAVED_SEARCH_MODEL> converter(Store<AppState> store);

  Widget buildSaveSearch(BuildContext context, SavedSearchViewModel<SAVED_SEARCH_MODEL> itemViewModel);

  void dismissBottomSheetIfNeeded(BuildContext context, SavedSearchViewModel<SAVED_SEARCH_MODEL> newVm);
}
