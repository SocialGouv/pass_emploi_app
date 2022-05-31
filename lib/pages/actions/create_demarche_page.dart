import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CreateDemarchePage extends StatelessWidget {
  CreateDemarchePage._();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateDemarchePage._());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: passEmploiAppBar(label: "Création d'une démarche", context: context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Text(
              "Créer une démarche personnalisée",
              style: TextStyles.textBaseBoldWithColor(AppColors.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: Text(
              "Les champs marqués d’une * sont obligatoires",
              style: TextStyles.textSRegular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
            child: Container(
              color: AppColors.primaryLighten,
              height: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Text(
              "Commentaire",
              style: TextStyles.textBaseBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Text(
              "*Description de la démarche",
              style: TextStyles.textBaseMedium,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, top: 8),
              child: Text(
                "255 caractères maximum",
                style: TextStyles.textXsRegular(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
