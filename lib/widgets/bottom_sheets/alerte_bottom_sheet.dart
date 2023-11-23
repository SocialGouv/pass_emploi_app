import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/alerte/init/alerte_initialize_action.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class AbstractAlerteBottomSheet<ALERTE_MODEL> extends StatelessWidget {
  final String analyticsScreenName;

  const AbstractAlerteBottomSheet({required this.analyticsScreenName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: analyticsScreenName,
      child: StoreConnector<AppState, AlerteViewModel<ALERTE_MODEL>>(
        onInit: (store) => store.dispatch(SaveSearchInitializeAction<ALERTE_MODEL>()),
        builder: (context, viewModel) => buildSaveSearch(context, viewModel),
        onWillChange: (previousVm, newVm) => dismissBottomSheetIfNeeded(context, newVm),
        converter: converter,
        distinct: true,
      ),
    );
  }

  AlerteViewModel<ALERTE_MODEL> converter(Store<AppState> store);

  Widget buildSaveSearch(BuildContext context, AlerteViewModel<ALERTE_MODEL> itemViewModel);

  void dismissBottomSheetIfNeeded(BuildContext context, AlerteViewModel<ALERTE_MODEL> newVm);
}
