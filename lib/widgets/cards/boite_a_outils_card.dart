import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:url_launcher/url_launcher.dart';

class BoiteAOutilsCard extends StatelessWidget {
  const BoiteAOutilsCard({
    Key? key,
    required this.outil,
  }) : super(key: key);

  final Outil outil;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Text(outil.title, style: TextStyles.textBaseBold),
                SizedBox(height: 16),
                Text(outil.description, style: TextStyles.textBaseRegular),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SepLine(16, 16),
            ),
            Center(
              child: Text(
                outil.actionLabel,
                style: TextStyles.textBaseBoldWithColor(AppColors.primary),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
