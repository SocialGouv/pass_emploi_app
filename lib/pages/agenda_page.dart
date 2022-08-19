import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/presentation/agenda_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class AgendaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: "todo",
      child: StoreConnector<AppState, AgendaPageViewModel>(
        onInit: (store) => store.dispatch(AgendaRequestAction(DateTime.now())),
        builder: (context, viewModel) => _scaffold(context, viewModel),
        converter: (store) => AgendaPageViewModel.create(store),
        distinct: true,
      ),
    );
  }

  Widget _scaffold(BuildContext context, AgendaPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Text("hey"),
    );
  }
}
