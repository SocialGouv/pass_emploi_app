import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_actions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_body.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_icon_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_subtitle.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_title.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class BaseCardS extends StatelessWidget {
  const BaseCardS();

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CardTag(
                icon: Icons.business_center_outlined,
                backgroundColor: AppColors.accent2Lighten,
                text: "Offre d'emploi",
                contentColor: AppColors.accent3,
              ),
              Expanded(child: SizedBox()),
              CardPillule(
                  icon: Icons.bolt,
                  text: "À réaliser",
                  contentColor: AppColors.accent2,
                  backgroundColor: AppColors.accent3Lighten),
              CardIconButton(AppIcons.delete, color: AppColors.primary, onPressed: () {})
            ],
          ),
          SizedBox(height: Margins.spacing_m),
          CardTitle("Titre de la carte sur trois lignes ou plus avec troncature auto à trois lignes"),
          SizedBox(height: Margins.spacing_base),
          CardSubtitle("Sous-titre card"),
          SizedBox(height: Margins.spacing_base),
          CardTag(
            icon: Icons.volunteer_activism,
            backgroundColor: AppColors.additional1Lighten,
            text: "Entreprise accueillante",
            contentColor: AppColors.accent2,
          ),
          SizedBox(height: Margins.spacing_base),
          CardBodyText(
              "Description texte_s pour apporter du complément, avec troncature automatique au bout de trois lignes si ça veut bien. Lorem ipsus im dorlor"),
          SizedBox(height: Margins.spacing_base),
          Wrap(
            spacing: Margins.spacing_base,
            runSpacing: Margins.spacing_s,
            children: [
              CardComplement(text: "Complément 1"),
              CardComplement(text: "Complément 2"),
              CardComplement(text: "Complément 3"),
              CardComplement(text: "Complément 4"),
            ],
          ),
          SizedBox(height: Margins.spacing_base),
          Wrap(
            spacing: Margins.spacing_s,
            runSpacing: Margins.spacing_s,
            children: [
              CardTag.secondary(text: "Tag info 1"),
              CardTag.secondary(text: "Tag info 2"),
              CardTag.secondary(text: "Tag info 3"),
            ],
          ),
          SizedBox(height: Margins.spacing_m),
          CardActions(actions: [
            SecondaryButton(
              label: "label",
              icon: AppIcons.delete,
              onPressed: () {},
            ),
            PrimaryActionButton(
              label: "label",
              icon: AppIcons.add_rounded,
              onPressed: () {},
            )
          ]), // TODO:
          SizedBox(height: Margins.spacing_m),
          PressedTip("Voir le détail"),
        ],
      ),
    );
  }
}
