import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/immersion_boulanger_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class BoulangerCampagneCard extends StatelessWidget {
  const BoulangerCampagneCard(this.item);
  final BoulangerCampagneItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        padding: EdgeInsets.zero,
        onTap: () {
          Navigator.push(context, ImmersionBoulangerPage.materialPageRoute());
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
                          Strings.boulangerCampagneTitle,
                          style: TextStyles.textBaseBold.copyWith(color: AppColors.contentColor),
                        ),
                      ),
                      SizedBox(width: Margins.spacing_m),
                    ],
                  ),
                  SizedBox(height: Margins.spacing_s),
                  PressedTip(
                    Strings.boulangerCampagneDescription,
                    textColor: AppColors.contentColor,
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                tooltip: "${Strings.closeDialog} ${Strings.boulangerCampagneTitle}",
                onPressed: item.onDismiss,
                icon: Icon(AppIcons.close_rounded, color: AppColors.contentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
