import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ImmersionListPage extends TraceableStatelessWidget {
  final List<Immersion> immersions;

  const ImmersionListPage(this.immersions) : super(name: AnalyticsScreenNames.immersionResults);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(label: Strings.immersionsTitle, withBackButton: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => _buildItem(context, immersions[index], index),
        separatorBuilder: (context, index) => Container(height: 16),
        itemCount: immersions.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, Immersion immersion, int index) {
    return DataCard(
      titre: immersion.metier,
      sousTitre: immersion.nomEtablissement,
      lieu: immersion.ville,
      dataTag: [immersion.secteurActivite],
      onTap: () => Navigator.push(context, ImmersionDetailsPage.materialPageRoute(immersion.id)),
    );
  }
}
