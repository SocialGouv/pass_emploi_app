import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
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
      itemCount: UserActionReferentielTypePresentation.all.length,
      itemBuilder: (context, index) {
        final type = UserActionReferentielTypePresentation.all[index];
        return ActionCategoryCard(
          onTap: () => onActionSelected?.call(type),
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

extension UserActionReferentielTypePresentation on UserActionReferentielType {
  static List<UserActionReferentielType> get all => [
        UserActionReferentielType.emploi,
        UserActionReferentielType.projetProfessionnel,
        UserActionReferentielType.cultureSportLoisirs,
        UserActionReferentielType.citoyennete,
        UserActionReferentielType.formation,
        UserActionReferentielType.logement,
        UserActionReferentielType.sante,
      ];
  String get label => switch (this) {
        UserActionReferentielType.emploi => 'Emploi',
        UserActionReferentielType.projetProfessionnel => 'Projet',
        UserActionReferentielType.cultureSportLoisirs => 'Sport',
        UserActionReferentielType.citoyennete => 'Citoyenneté',
        UserActionReferentielType.formation => 'Formation',
        UserActionReferentielType.logement => 'Logement',
        UserActionReferentielType.sante => 'Santé',
      };

  String get description => switch (this) {
        UserActionReferentielType.emploi => "Recherches, candidatures",
        UserActionReferentielType.projetProfessionnel => "Définir un projet professionnel",
        UserActionReferentielType.cultureSportLoisirs => "Cours de sport, salle, sorties",
        UserActionReferentielType.citoyennete => "Démarches, passer le permis",
        UserActionReferentielType.formation => "En présentiel ou en ligne",
        UserActionReferentielType.logement => "Recherches de logement",
        UserActionReferentielType.sante => "Rendez-vous médicaux",
      };

  IconData get icon => switch (this) {
        UserActionReferentielType.emploi => AppIcons.emploi,
        UserActionReferentielType.projetProfessionnel => AppIcons.projetPro,
        UserActionReferentielType.cultureSportLoisirs => AppIcons.sportLoisirs,
        UserActionReferentielType.citoyennete => AppIcons.citoyennete,
        UserActionReferentielType.formation => AppIcons.formation,
        UserActionReferentielType.logement => AppIcons.logement,
        UserActionReferentielType.sante => AppIcons.sante,
      };
}
