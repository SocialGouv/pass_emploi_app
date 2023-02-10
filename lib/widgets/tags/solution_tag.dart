import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';

extension JobTagTypeExt on SolutionType {
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
