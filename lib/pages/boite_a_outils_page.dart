import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BoiteAOutilsPage extends TraceableStatelessWidget {
  final _outils = LocalOutilRepository().getOutils();

  BoiteAOutilsPage() : super(name: AnalyticsScreenNames.toolbox);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBlue,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, index) => SizedBox(height: 16),
          itemCount: _outils.length,
          itemBuilder: (context, index) => _item(
                context: context,
                outil: _outils[index],
                isLastItem: index == _outils.length - 1,
              )),
    );
  }

  Widget _item({required BuildContext context, required Outil outil, required bool isLastItem}) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: InkWell(
            onTap: () {
              MatomoTracker.trackScreenWithName(outil.urlRedirect, AnalyticsScreenNames.toolbox);
              launch(outil.urlRedirect);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (outil.imagePath != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/${outil.imagePath!}",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    SizedBox(height: 16),
                    Text(outil.title, style: TextStyles.textMdMedium),
                    SizedBox(height: 16),
                    Text(outil.description, style: TextStyles.textSmRegular()),
                    SizedBox(height: 16),
                  ]),
                ),
                Container(height: 1, color: AppColors.bluePurpleAlpha20),
                SizedBox(height: 16),
                Center(child: Text(outil.actionLabel, style: TextStyles.textMdMedium)),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (isLastItem) SizedBox(height: 16),
      ],
    );
  }
}
