import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class RechercheHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.rechercheV2Home,
      child: SingleChildScrollView(
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
                icon: AppIcons.description_rounded,
                onTap: () => Navigator.push(context, RechercheOffreEmploiPage.materialPageRoute(onlyAlternance: false)),
              ),
              SizedBox(height: Margins.spacing_base),
              _BlocSolution(
                title: Strings.rechercheHomeOffresAlternanceTitle,
                subtitle: Strings.rechercheHomeOffresAlternanceSubtitle,
                icon: AppIcons.description_rounded,
                onTap: () => Navigator.push(context, RechercheOffreEmploiPage.materialPageRoute(onlyAlternance: true)),
              ),
              SizedBox(height: Margins.spacing_base),
              _BlocSolution(
                title: Strings.rechercheHomeOffresImmersionTitle,
                subtitle: Strings.rechercheHomeOffresImmersionSubtitle,
                drawable: Drawables.icOffresEmploi, //TODO(1356) quand Adrien aura mis les ic material
                onTap: () => Navigator.push(context, RechercheOffreImmersionPage.materialPageRoute()),
              ),
              SizedBox(height: Margins.spacing_base),
              _BlocSolution(
                title: Strings.rechercheHomeOffresServiceCiviqueTitle,
                subtitle: Strings.rechercheHomeOffresServiceCiviqueSubtitle,
                icon: AppIcons.description_rounded,
                onTap: () => Navigator.push(context, RechercheOffreServiceCiviquePage.materialPageRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlocSolution extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() onTap;

  const _BlocSolution({
    required this.title,
    required this.subtitle,
    required this.icon,
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
                Icon(icon, color: AppColors.primary),
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
                  Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor, size: Dimens.icon_size_base),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
