import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/boite_a_outils_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/cards/boite_a_outils_card.dart';

class BoiteAOutilsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.toolbox,
      child: StoreConnector<AppState, BoiteAOutilsViewModel>(
        converter: (store) => BoiteAOutilsViewModel.create(store),
        builder: _builder,
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, BoiteAOutilsViewModel viewModel) {
    return Container(
      color: AppColors.grey100,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, index) => SizedBox(height: Margins.spacing_base),
          itemCount: viewModel.outils.length,
          itemBuilder: (context, index) => buildBoiteAOutilsCard(viewModel.outils, index)),
    );
  }

  Widget buildBoiteAOutilsCard(List<Outil> outils, int index) {
    if (index == outils.length - 1) {
      return Column(children: [
        BoiteAOutilsCard(outil: outils[index]),
        SizedBox(height: Margins.spacing_base),
      ]);
    } else if (index == 0) {
      return Column(children: [
        SizedBox(height: Margins.spacing_base),
        BoiteAOutilsCard(outil: outils[index]),
      ]);
    }
    return BoiteAOutilsCard(outil: outils[index]);
  }
}
