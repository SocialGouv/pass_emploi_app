import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/pages/benevolat_page.dart';
import 'package:pass_emploi_app/pages/la_bonne_alternance_page.dart';
import 'package:pass_emploi_app/temp/cje_page.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class BoiteAOutilsCard extends StatelessWidget {
  final Outil outil;

  const BoiteAOutilsCard({super.key, required this.outil});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      title: outil.title,
      body: outil.description,
      imagePath: outil.imagePath,
      imageAlt: outil.imageAlt,
      pressedTip: outil.actionLabel != null ? PressedTip.externalLink(outil.actionLabel!) : null,
      linkRole: outil.redirectMode is OutilExternalRedirectMode,
      onTap: () {
        return switch (outil.redirectMode) {
          final OutilExternalRedirectMode redirect => _launchExternalRedirect(redirect.url),
          final OutilInternalRedirectMode redirect => _pushInternalRedirect(context, redirect.internalLink),
        };
      },
    );
  }

  void _launchExternalRedirect(String url) {
    PassEmploiMatomoTracker.instance.trackOutlink(url);
    launchExternalUrl(url);
  }

  Future<void> _pushInternalRedirect(BuildContext context, OutilInternalLink internalLink) {
    return switch (internalLink) {
      OutilInternalLink.benevolat => Navigator.of(context).push(BenevolatPage.materialPageRoute()),
      OutilInternalLink.laBonneAlternance => Navigator.of(context).push(LaBonneAlternancePage.materialPageRoute()),
      OutilInternalLink.cje => Navigator.of(context).push(CjePage.materialPageRoute(CjePageSource.boite_a_outils)),
    };
  }
}
