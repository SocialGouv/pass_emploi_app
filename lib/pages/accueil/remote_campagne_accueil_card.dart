import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class RemoteCampagneAccueilCard extends StatelessWidget {
  const RemoteCampagneAccueilCard(this.item);
  final RemoteCampagneAccueilItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        padding: EdgeInsets.zero,
        onTap: () {
          PassEmploiMatomoTracker.instance.trackOutlink(item.url);
          launchExternalUrl(item.url);
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(Margins.spacing_base),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyles.textMBold.copyWith(color: AppColors.contentColor),
                        ),
                      ),
                      SizedBox(width: Margins.spacing_m),
                    ],
                  ),
                  SizedBox(height: Margins.spacing_s),
                  PressedTip.externalLink(
                    item.cta,
                    textColor: AppColors.contentColor,
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                tooltip: "${Strings.closeDialog} ${item.title}",
                onPressed: item.onDismissed,
                icon: Icon(AppIcons.close_rounded, color: AppColors.contentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
