import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class CreateUserActionFormStep1 extends StatelessWidget {
  const CreateUserActionFormStep1({super.key, required this.onActionTypeSelected});
  final void Function(UserActionReferentielType) onActionTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Margins.spacing_m),
        Text(Strings.user_action_subtitle_step_1, style: TextStyles.textBaseBold),
        const SizedBox(height: Margins.spacing_m),
        ActionCategorySelector(onActionSelected: onActionTypeSelected),
        const SizedBox(height: Margins.spacing_huge),
      ],
    );
  }
}

class ActionCategorySelector extends StatelessWidget {
  const ActionCategorySelector({super.key, this.onActionSelected});
  final void Function(UserActionReferentielType)? onActionSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Margins.spacing_base,
        crossAxisSpacing: Margins.spacing_base,
      ),
      itemCount: UserActionReferentiel.all.length,
      itemBuilder: (context, index) {
        final type = UserActionReferentiel.all[index];
        return ActionCategoryCard(
          onTap: () => onActionSelected?.call(type.type),
          icon: type.icon,
          label: type.label,
          description: type.description,
        );
      },
    );
  }
}

class ActionCategoryCard extends StatelessWidget {
  const ActionCategoryCard(
      {super.key, required this.icon, required this.label, required this.description, required this.onTap});
  final IconData icon;
  final String label;
  final String description;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(height: Margins.spacing_s),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyles.textBaseBold.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: Margins.spacing_s),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyles.textSRegular(color: AppColors.grey800),
          ),
        ],
      ),
    );
  }
}

enum UserActionReferentielType {
  emploi,
  projetProfessionnel,
  cultureSportLoisirs,
  citoyennete,
  formation,
  logement,
  sante,
}

class UserActionReferentiel {
  final UserActionReferentielType type;
  final String label;
  final String description;
  final IconData icon;

  const UserActionReferentiel(this.type, this.label, this.description, this.icon);

  static const emploi = UserActionReferentiel(
    UserActionReferentielType.emploi,
    'Emploi',
    "Recherches, candidatures",
    AppIcons.emploi,
  );
  static const projetProfessionnel = UserActionReferentiel(
    UserActionReferentielType.projetProfessionnel,
    'Projet Pro',
    "Définir un projet professionnel",
    AppIcons.projetPro,
  );
  static const cultureSportLoisirs = UserActionReferentiel(
    UserActionReferentielType.cultureSportLoisirs,
    'Sport, loisirs',
    "Cours de sport, salle, sorties",
    AppIcons.sportLoisirs,
  );
  static const citoyennete = UserActionReferentiel(
    UserActionReferentielType.citoyennete,
    'Citoyenneté',
    "Démarches, passer le permis",
    AppIcons.citoyennete,
  );
  static const formation = UserActionReferentiel(
    UserActionReferentielType.formation,
    'Formation',
    "En présentiel ou en ligne",
    AppIcons.formation,
  );
  static const logement = UserActionReferentiel(
    UserActionReferentielType.logement,
    'Logement',
    "Recherches de logement",
    AppIcons.logement,
  );
  static const sante = UserActionReferentiel(
    UserActionReferentielType.sante,
    'Santé',
    "Rendez-vous médicaux",
    AppIcons.sante,
  );

  static const all = [
    emploi,
    projetProfessionnel,
    cultureSportLoisirs,
    citoyennete,
    formation,
    logement,
    sante,
  ];
}
