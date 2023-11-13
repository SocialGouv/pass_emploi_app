import 'package:flutter/material.dart';
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
  const BaseCardS({
    required this.title,
    this.subtitle,
    this.body,
    this.tag,
    this.pillule,
    this.iconButton,
    this.onTap,
    this.withEntrepriseAccueillante = false,
  });

  final String title;
  final CardTag? tag;
  final CardPillule? pillule;
  final CardIconButton? iconButton;
  final String? subtitle;
  final String? body;
  final bool withEntrepriseAccueillante;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSimpleCard = tag == null && pillule == null;
    return CardContainer(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSimpleCard) ...[
            Row(
              children: [
                if (tag != null) tag!,
                Expanded(child: SizedBox()),
                if (pillule != null) pillule!,
                if (iconButton != null) iconButton!,
              ],
            ),
            SizedBox(height: Margins.spacing_base),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: CardTitle(title)),
              if (isSimpleCard) iconButton!,
            ],
          ),
          SizedBox(height: Margins.spacing_base),
          if (subtitle != null) ...[
            CardSubtitle(subtitle!),
            SizedBox(height: Margins.spacing_base),
          ],
          if (body != null) ...[
            CardBodyText(body!),
            SizedBox(height: Margins.spacing_base),
          ],
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
          SizedBox(height: Margins.spacing_base),
          if (withEntrepriseAccueillante) ...[
            CardTag.entrepriseAccueillante(),
            SizedBox(height: Margins.spacing_base),
          ],
          SizedBox(height: Margins.spacing_s),
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
          ]),
          SizedBox(height: Margins.spacing_m),
          PressedTip("Voir le détail"),
        ],
      ),
    );
  }
}
