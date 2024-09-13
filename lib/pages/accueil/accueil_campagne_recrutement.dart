import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/external_links.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class CampagneRecrutementCard extends StatelessWidget {
  const CampagneRecrutementCard(this.campagneRecrutementCej);

  final CampagneRecrutementItem campagneRecrutementCej;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        backgroundColor: Colors.transparent,
        splashColor: AppColors.primaryDarken.withOpacity(0.5),
        padding: EdgeInsets.zero,
        onTap: () => launchExternalUrl(ExternalLinks.campagneRecrutement),
        image: DecorationImage(
          image: AssetImage(Drawables.campagneRecrutementBg),
          fit: BoxFit.cover,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(Margins.spacing_base),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Margins.spacing_xs),
                        child: Transform.rotate(
                          angle: (2 * pi / 360) * 8,
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: Semantics(
                              excludeSemantics: true,
                              child: Image.asset(
                                Drawables.logoInProgress,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Margins.spacing_m),
                      Expanded(
                        child: Text(
                          Strings.accueilCampagneRecrutementLabel,
                          style: TextStyles.textMBold.copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: Margins.spacing_m),
                    ],
                  ),
                  SizedBox(height: Margins.spacing_s),
                  PressedTip.externalLink(
                    Strings.accueilCampagneRecrutementPressedTip,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                tooltip: "${Strings.closeDialog} ${Strings.accueilCampagneRecrutementLabel}",
                onPressed: campagneRecrutementCej.onDismiss,
                icon: Icon(AppIcons.close_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
