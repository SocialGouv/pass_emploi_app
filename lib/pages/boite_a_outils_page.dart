import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/cards/boite_a_outils_card.dart';

class BoiteAOutilsPage extends TraceableStatelessWidget {
  final _outils = LocalOutilRepository().getOutils();

  BoiteAOutilsPage() : super(name: AnalyticsScreenNames.toolbox);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey100,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, index) => SizedBox(height: Margins.spacing_base),
          itemCount: _outils.length,
          itemBuilder: (context, index) => buildBoiteAOutilsCard(index)),
    );
  }

  Widget buildBoiteAOutilsCard(int index) {
    if (index == _outils.length - 1) {
      return Column(children: [
        BoiteAOutilsCard(outil: _outils[index]),
        SizedBox(height: Margins.spacing_base),
      ]);
    } else if (index == 0) {
      return Column(children: [
        SizedBox(height: Margins.spacing_base),
        BoiteAOutilsCard(outil: _outils[index]),
      ]);
    }
    return BoiteAOutilsCard(outil: _outils[index]);
  }
}
