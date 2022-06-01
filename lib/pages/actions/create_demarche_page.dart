import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
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
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, top: 8),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.contentColor,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, top: 8),
              child: Text(
                "0/255",
                style: TextStyles.textXsRegular(),
              ),
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
              "Quand",
              style: TextStyles.textBaseBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Text(
              "*Sélectionner une date d'échéance",
              style: TextStyles.textBaseMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, top: 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.contentColor,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      icon: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.calendar_today,
                            color: AppColors.contentColor,
                          ))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, top: 32),
            child: PrimaryActionButton(
              label: Strings.addALaDemarche,
              onPressed: () {
                Navigator.of(context).push(CreateDemarchePage.materialPageRoute());
              },
            ),
          ),
        ],
      ),
    );
  }
}
