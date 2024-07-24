import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/cgu_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

class CguPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.cguPage,
      child: StoreConnector<AppState, CguPageViewModel>(
        builder: (context, viewModel) => _Scaffold(
          body: switch (viewModel.displayState) {
            CguNeverAcceptedDisplayState() => CguNeverAccepted(),
            final CguUpdateRequiredDisplayState vm => CguUpdateRequired(vm.lastUpdateLabel, vm.changes),
            null => SizedBox.shrink(),
          },
        ),
        converter: CguPageViewModel.create,
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final Widget body;

  const _Scaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cgu")),
      body: body,
    );
  }
}

class CguNeverAccepted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("CguNeverAccepted");
  }
}

class CguUpdateRequired extends StatelessWidget {
  final String lastUpdateLabel;
  final List<String> changes;

  const CguUpdateRequired(this.lastUpdateLabel, this.changes);

  @override
  Widget build(BuildContext context) {
    return Text("CguUpdateRequired");
  }
}
