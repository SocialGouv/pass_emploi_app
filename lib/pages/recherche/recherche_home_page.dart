import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_raclette_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class RechercheHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Nos offres",
            style: TextStyles.textSMedium(color: AppColors.primary),
          ),
          SizedBox(height: Margins.spacing_base),
          CardContainer(
            child: Text(
              "Offres emploi",
              style: TextStyles.textSMedium(),
            ),
            onTap: () => Navigator.push(context, RechercheRaclettePage.materialPageRoute()),
          ),
        ],
      ),
    );
  }
}
