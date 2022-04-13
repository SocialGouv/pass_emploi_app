import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class BoiteAOutilsCard extends StatelessWidget {
  const BoiteAOutilsCard({
    Key? key,
    required this.outil,
  }) : super(key: key);

  final Outil outil;

  @override
  Widget build(BuildContext context) {
    final roundedCornerShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: roundedCornerShape,
      child: InkWell(
        customBorder: roundedCornerShape,
        onTap: () {
          MatomoTracker.trackOutlink(outil.urlRedirect);
          launchExternalUrl(outil.urlRedirect);
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
                SizedBox(height: Margins.spacing_base),
                Text(outil.title, style: TextStyles.textBaseBold),
                SizedBox(height: Margins.spacing_base),
                Text(outil.description, style: TextStyles.textBaseRegular),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
              child: SepLine(Margins.spacing_base, Margins.spacing_base),
            ),
            Center(
              child: Text(
                outil.actionLabel,
                style: TextStyles.textBaseBoldWithColor(AppColors.primary),
              ),
            ),
            SizedBox(height: Margins.spacing_base),
          ],
        ),
      ),
    );
  }
}
