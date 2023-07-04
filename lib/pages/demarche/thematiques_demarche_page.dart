import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ThematiquesDemarchePage extends StatelessWidget {
  const ThematiquesDemarchePage({super.key});

  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => ThematiquesDemarchePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.thematiquesDemarche,
      child: StoreConnector<AppState, ThematiquesDemarchePageViewModel>(
        onInit: (store) => store.dispatch(ThematiquesDemarcheRequestAction()),
        converter: (store) => ThematiquesDemarchePageViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold(this.viewModel);
  final ThematiquesDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.demarcheThematiqueTitle),
      body: Placeholder(),
    );
  }
}
