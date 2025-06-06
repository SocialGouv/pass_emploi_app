import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class CreateUserActionFormStep1 extends StatelessWidget {
  const CreateUserActionFormStep1({super.key, required this.onActionTypeSelected});

  final void Function(UserActionReferentielType) onActionTypeSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Tracker(
        tracking: AnalyticsScreenNames.createUserActionStep1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Margins.spacing_s),
              Semantics(
                container: true,
                header: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserActionStepperTexts(index: 1),
                    const SizedBox(height: Margins.spacing_s),
                    Text(Strings.userActionTitleStep1,
                        style: TextStyles.textMBold.copyWith(color: AppColors.contentColor)),
                  ],
                ),
              ),
              const SizedBox(height: Margins.spacing_m),
              Semantics(
                sortKey: const OrdinalSortKey(1),
                child: Text(Strings.userActionSubtitleStep1, style: TextStyles.textBaseBold),
              ),
              const SizedBox(height: Margins.spacing_m),
              Semantics(
                sortKey: const OrdinalSortKey(2),
                child: ActionCategorySelector(onActionSelected: onActionTypeSelected),
              ),
              const SizedBox(height: Margins.spacing_base),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCategorySelector extends StatelessWidget {
  const ActionCategorySelector({super.key, required this.onActionSelected});

  final void Function(UserActionReferentielType) onActionSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      semanticChildCount: UserActionReferentielTypePresentation.all.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Margins.spacing_base,
        crossAxisSpacing: Margins.spacing_base,
        childAspectRatio: _responsiveChildAspectRatioForA11y(context),
      ),
      itemCount: UserActionReferentielTypePresentation.all.length,
      itemBuilder: (context, index) {
        final type = UserActionReferentielTypePresentation.all[index];
        return ActionCategoryCard(
          onTap: () => onActionSelected.call(type),
          icon: type.icon,
          label: type.label,
          description: type.description,
        );
      },
    );
  }

  double _responsiveChildAspectRatioForA11y(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    if (height < MediaSizes.height_xs) return textScaleFactor > 1 ? 0.5 : 2 / 3;
    // manualy ajusted for a11y at 235%
    return min(1, 0.8 / textScaleFactor);
  }
}

class ActionCategoryCard extends StatelessWidget {
  const ActionCategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
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
            Flexible(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyles.textSRegular(color: AppColors.grey800),
              ),
            ),
          ],
        ),
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
        UserActionReferentielType.emploi => Strings.userActionEmploiLabel,
        UserActionReferentielType.projetProfessionnel => Strings.userActionProjetProfessionnelLabel,
        UserActionReferentielType.cultureSportLoisirs => Strings.userActionCultureSportLoisirsLabel,
        UserActionReferentielType.citoyennete => Strings.userActionCitoyenneteLabel,
        UserActionReferentielType.formation => Strings.userActionFormationLabel,
        UserActionReferentielType.logement => Strings.userActionLogementLabel,
        UserActionReferentielType.sante => Strings.userActionSanteLabel,
      };

  String get description => switch (this) {
        UserActionReferentielType.emploi => Strings.userActionEmploiDescription,
        UserActionReferentielType.projetProfessionnel => Strings.userActionProjetProfessionnelDescription,
        UserActionReferentielType.cultureSportLoisirs => Strings.userActionCultureSportLoisirsDescription,
        UserActionReferentielType.citoyennete => Strings.userActionCitoyenneteDescription,
        UserActionReferentielType.formation => Strings.userActionFormationDescription,
        UserActionReferentielType.logement => Strings.userActionLogementDescription,
        UserActionReferentielType.sante => Strings.userActionSanteDescription,
      };

  IconData get icon => switch (this) {
        UserActionReferentielType.emploi => AppIcons.work_outline_rounded,
        UserActionReferentielType.projetProfessionnel => AppIcons.ads_click_rounded,
        UserActionReferentielType.cultureSportLoisirs => AppIcons.sports_football_outlined,
        UserActionReferentielType.citoyennete => AppIcons.attach_file,
        UserActionReferentielType.formation => AppIcons.school_outlined,
        UserActionReferentielType.logement => AppIcons.door_front_door_outlined,
        UserActionReferentielType.sante => AppIcons.local_hospital_outlined,
      };
}
