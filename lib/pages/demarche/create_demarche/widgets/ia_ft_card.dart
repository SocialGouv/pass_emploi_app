import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class IaFtCard extends StatelessWidget {
  const IaFtCard({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        onTap: onPressed,
        gradient: LinearGradient(
          colors: AppColors.gradientSecondary,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: ExcludeSemantics(
                child: SvgPicture.asset(Drawables.iaFtIllustration),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardTag(
                  backgroundColor: Colors.white,
                  text: Strings.newFeature,
                  contentColor: AppColors.primaryDarken,
                  icon: AppIcons.bolt_outlined,
                ),
                SizedBox(height: Margins.spacing_s),
                Text(Strings.topDemarchesTitle, style: TextStyles.textBaseBold.copyWith(color: Colors.white)),
                SizedBox(height: Margins.spacing_xs),
                Text(Strings.topDemarchesSubtitle, style: TextStyles.textSRegular().copyWith(color: Colors.white)),
                SizedBox(height: Margins.spacing_xs),
                PressedTip(
                  Strings.topDemarchesPressedTip,
                  textColor: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
