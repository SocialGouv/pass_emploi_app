import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/pages/benevolat_page.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class BoiteAOutilsCard extends StatelessWidget {
  final Outil outil;

  const BoiteAOutilsCard({super.key, required this.outil});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: BaseCard(
        title: outil.title,
        body: outil.description,
        imagePath: outil.imagePath,
        pressedTip: outil.actionLabel != null ? PressedTip.externalLink(outil.actionLabel!) : null,
        onTap: () {
          return switch (outil.redirectMode) {
            final OutilExternalRedirectMode redirect => _launchExternalRedirect(redirect.url),
            final OutilInternalRedirectMode redirect => _pushInternalRedirect(context, redirect.internalLink),
          };
        },
      ),
    );
  }

  void _launchExternalRedirect(String url) {
    PassEmploiMatomoTracker.instance.trackOutlink(url);
    launchExternalUrl(url);
  }

  Future<void> _pushInternalRedirect(BuildContext context, OutilInternalLink internalLink) {
    return switch (internalLink) {
      OutilInternalLink.benevolat => Navigator.of(context).push(BenevolatPage.materialPageRoute()),
    };
  }
}
