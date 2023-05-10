import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class JobTag extends StatelessWidget {
  final String label;
  final Color contentColor;
  final Color backgroundColor;
  const JobTag({
    Key? key,
    required this.label,
    this.contentColor = AppColors.contentColor,
    this.backgroundColor = AppColors.additional1Lighten,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
      ),
      child: Text(label, style: TextStyles.textSMedium(color: contentColor)),
    );
  }
}

extension JobSolutionTypeExt on SolutionType {
  Widget toJobTag() {
    switch (this) {
      case SolutionType.OffreEmploi:
        return JobTag(label: Strings.savedSearchEmploiTag, backgroundColor: AppColors.additional4Ligten);
      case SolutionType.Alternance:
        return JobTag(label: Strings.savedSearchAlternanceTag, backgroundColor: AppColors.additional3Ligthen);
      case SolutionType.Immersion:
        return JobTag(label: Strings.savedSearchImmersionTag, backgroundColor: AppColors.additional1Lighten);
      case SolutionType.ServiceCivique:
        return JobTag(label: Strings.savedSearchServiceCiviqueTag, backgroundColor: AppColors.additional2Ligthen);
    }
  }
}

extension JobSuggestionTypeExt on SuggestionType {
  Widget toJobTag() {
    switch (this) {
      case SuggestionType.emploi:
        return JobTag(label: Strings.savedSearchEmploiTag, backgroundColor: AppColors.additional4Ligten);
      case SuggestionType.alternance:
        return JobTag(label: Strings.savedSearchAlternanceTag, backgroundColor: AppColors.additional3Ligthen);
      case SuggestionType.immersion:
        return JobTag(label: Strings.savedSearchImmersionTag, backgroundColor: AppColors.additional1Lighten);
      case SuggestionType.civique:
        return JobTag(label: Strings.savedSearchServiceCiviqueTag, backgroundColor: AppColors.additional2Ligthen);
    }
  }
}

