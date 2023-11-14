import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_actions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';

class TestCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('Test Appbar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: BaseCard(
          title:
              "Titre de la carte sur trois lignes ou plus avec troncature auto à trois lignes j'adore les champignons by the way. En plus c'est la saison c'est cool pouruqoi ne pas en profiter après tout ?",
          tag: CardTag.serviceCivique(),
          pillule: CardPillule.late(),
          iconButton: IconButton(icon: Icon(AppIcons.delete), color: AppColors.primary, onPressed: () {}),
          subtitle: "Sous-titre card",
          body:
              "Description texte_s pour apporter du complément, avec troncature automatique au bout de trois lignes si ça veut bien. Lorem ipsus im dorlor",
          onTap: () {},
          additionalChild: CardTag.entrepriseAccueillante(),
          actions: CardActions(actions: [
            SecondaryButton(label: "label", icon: AppIcons.delete, onPressed: () {}),
            PrimaryActionButton(label: "label", icon: AppIcons.add_rounded, onPressed: () {})
          ]),
          complements: [
            CardComplement(icon: Icons.settings, text: "Complément 1"),
            CardComplement(icon: Icons.settings, text: "Complément 2"),
            CardComplement(icon: Icons.settings, text: "Complément 3"),
            CardComplement(icon: Icons.settings, text: "Complément 4")
          ],
          secondaryTags: [
            CardTag.secondary(text: "Tag info 1"),
            CardTag.secondary(text: "Tag info 2"),
            CardTag.secondary(text: "Tag info 3"),
          ],
        ),
      ),
    );
  }
}
