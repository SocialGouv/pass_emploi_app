import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:redux/redux.dart';

abstract class AbstractSavedSearchBottomSheet<SAVED_SEARCH_MODEL> extends TraceableStatefulWidget {
  final String analyticsScreenName;
  final SavedSearchState<SAVED_SEARCH_MODEL> Function(Store<AppState> store) selectState;

  const AbstractSavedSearchBottomSheet({
    required this.analyticsScreenName,
    required this.selectState,
    Key? key,
  }) : super(name: analyticsScreenName, key: key);

  @override
  State<AbstractSavedSearchBottomSheet<SAVED_SEARCH_MODEL>> createState() => AbstractSavedSearchBottomSheetState<SAVED_SEARCH_MODEL>();
}

abstract class AbstractSavedSearchBottomSheetState<SAVED_SEARCH_MODEL> extends State<AbstractSavedSearchBottomSheet<SAVED_SEARCH_MODEL>> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,  SavedSearchViewModel<SAVED_SEARCH_MODEL> >(
      onInit: (store) => store.dispatch(CreateSavedSearchAction<SAVED_SEARCH_MODEL>),
      builder: (context, viewModel) => buildSaveSearch(context, viewModel),
      onWillChange: (previousVm, newVm) => dismissBottomSheetIfNeeded(context, newVm),
      converter: converter,
      distinct: true,
    );
  }

  SavedSearchViewModel<SAVED_SEARCH_MODEL> converter(Store<AppState> store);

  Widget buildSaveSearch(BuildContext context, SavedSearchViewModel<SAVED_SEARCH_MODEL> itemViewModel);

  dismissBottomSheetIfNeeded(BuildContext context, SavedSearchViewModel<SAVED_SEARCH_MODEL> newVm);
}
