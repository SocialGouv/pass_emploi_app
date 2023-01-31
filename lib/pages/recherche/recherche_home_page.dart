import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class RechercheHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.rechercheV2Home,
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Strings.rechercheHomeNosOffres,
              style: TextStyles.textLBold(color: AppColors.primary),
            ),
            SizedBox(height: Margins.spacing_base),
            _BlocSolution(
              title: Strings.rechercheHomeOffresEmploiTitle,
              subtitle: Strings.rechercheHomeOffresEmploiSubtitle,
              drawable: Drawables.icOffresEmploi,
              onTap: () => Navigator.push(context, RechercheOffrePage.materialPageRoute()),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlocSolution extends StatelessWidget {
  final String title;
  final String subtitle;
  final String drawable;
  final void Function() onTap;

  const _BlocSolution({
    required this.title,
    required this.subtitle,
    required this.drawable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: Margins.spacing_base),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(drawable),
                SizedBox(width: Margins.spacing_base),
                Text(title, style: TextStyles.textMBold),
              ],
            ),
            SizedBox(height: Margins.spacing_base),
            Text(subtitle, style: TextStyles.textBaseRegular),
            SizedBox(height: Margins.spacing_m),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(Strings.rechercheHomeVoirLaListe, style: TextStyles.textBaseRegular),
                  SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor, height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
