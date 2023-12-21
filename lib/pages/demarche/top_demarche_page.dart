import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_custom_demarche.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step3_page.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/demarche/top_demarche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_du_referentiel_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class TopDemarchePage extends StatelessWidget {
  const TopDemarchePage({super.key});

  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => TopDemarchePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.topDemarches,
      child: StoreConnector<AppState, TopDemarchePageViewModel>(
        onInit: (store) => store.dispatch(TopDemarcheRequestAction()),
        converter: (store) => TopDemarchePageViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold(this.viewModel);

  final TopDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.topDemarchesTitle),
      body: _Body(viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);

  final TopDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _TopDemarcheList(viewModel: viewModel),
          const SizedBox(height: Margins.spacing_xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
            child: CreateCustomDemarche(),
          ),
        ],
      ),
    );
  }
}

class _TopDemarcheList extends StatelessWidget {
  const _TopDemarcheList({
    required this.viewModel,
  });

  final TopDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: viewModel.demarches.length,
      padding: const EdgeInsets.all(Margins.spacing_m),
      separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
      itemBuilder: (context, index) {
        final demarche = viewModel.demarches[index];
        final id = demarche.demarcheId;
        final source = TopDemarcheSource();
        return DemarcheDuReferentielCard(
          source: source,
          idDemarche: id,
          onTap: () {
            Navigator.push(context, CreateDemarcheStep3Page.materialPageRoute(id, source)).then((value) {
              // forward result to previous page
              if (value != null) Navigator.pop(context, value);
            });
          },
        );
      },
    );
  }
}
