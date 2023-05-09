import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/presentation/cv/cv_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CvListPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CvListPage());

  const CvListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.cvListPage,
      child: StoreConnector<AppState, CvViewModel>(
        onInit: (store) => store.dispatch(CvRequestAction()),
        converter: (store) => CvViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel: viewModel),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final CvViewModel viewModel;

  const _Scaffold({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(title: Strings.cvListPageTitle),
        body: Column(
          children: [
            Text(Strings.cvListPageSubtitle),
            // Expanded(child: _CvListView(viewModel.cvList))
          ],
        ));
  }
}
