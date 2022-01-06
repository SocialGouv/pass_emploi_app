import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/immersion_list_item.dart';

class ImmersionListPage extends TraceableStatelessWidget {
  final List<Immersion> immersions;

  const ImmersionListPage(this.immersions) : super(name: AnalyticsScreenNames.immersionResults);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(title: Text(Strings.immersionsTitle, style: TextStyles.textLgMedium)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => _buildItem(context, immersions[index], index),
        separatorBuilder: (context, index) => Container(height: 1, color: AppColors.bluePurpleAlpha20),
        itemCount: immersions.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, Immersion immersion, int index) {
    return index == 0 ? _buildFirstItem(context, immersion) : _buildImmersionItem(context, immersion);
  }

  Widget _buildFirstItem(BuildContext context, Immersion immersion) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
      child: _buildImmersionItem(context, immersion),
    );
  }

  Widget _buildImmersionItem(BuildContext context, Immersion immersion) {
    return Container(
      color: Colors.white,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => Navigator.push(context, ImmersionDetailsPage.materialPageRoute(immersion.id)),
          splashColor: AppColors.bluePurple,
          child: ImmersionListItem(immersion),
        ),
      ),
    );
  }
}
