import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
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

extension JobOffreTypeExt on OffreType {
  Widget toJobTag() {
    switch (this) {
      case OffreType.emploi:
        return JobTag(label: Strings.savedSearchEmploiTag, backgroundColor: AppColors.additional4Ligten);
      case OffreType.alternance:
        return JobTag(label: Strings.savedSearchAlternanceTag, backgroundColor: AppColors.additional3Ligthen);
      case OffreType.immersion:
        return JobTag(label: Strings.savedSearchImmersionTag, backgroundColor: AppColors.additional1Lighten);
      case OffreType.serviceCivique:
        return JobTag(label: Strings.savedSearchServiceCiviqueTag, backgroundColor: AppColors.additional2Ligthen);
    }
  }
}
