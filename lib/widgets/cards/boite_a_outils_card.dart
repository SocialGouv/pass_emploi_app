import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/outil.dart';
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
      pressedTip: PressedTip.externalLink(outil.actionLabel),
      onTap: () {
        PassEmploiMatomoTracker.instance.trackOutlink(outil.urlRedirect);
        launchExternalUrl(outil.urlRedirect);
      },
    );
  }
}
