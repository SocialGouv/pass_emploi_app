import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color contentColor;
  final IconData? icon;
  final String? semanticsLabel;

  const CardTag({
    required this.backgroundColor,
    required this.text,
    required this.contentColor,
    this.icon,
    this.semanticsLabel,
  });

  CardTag.evenement({
    required this.text,
  })  : icon = AppIcons.event,
        backgroundColor = AppColors.accent1Lighten,
        contentColor = AppColors.additional3,
        semanticsLabel = null;

  CardTag.warning({
    required this.text,
  })  : icon = null,
        backgroundColor = AppColors.warningLighten,
        contentColor = AppColors.warning,
        semanticsLabel = null;

  CardTag.secondary({
    required this.text,
    this.icon,
    this.semanticsLabel,
  })  : backgroundColor = AppColors.primaryLighten,
        contentColor = AppColors.primary;

  CardTag.emploi()
      : icon = Icons.business_center_outlined,
        backgroundColor = AppColors.additional2Lighten,
        text = Strings.emploiTag,
        contentColor = AppColors.accent3,
        semanticsLabel = null;

  CardTag.alternance()
      : icon = Icons.business_center_outlined,
        backgroundColor = AppColors.additional4Lighten,
        text = Strings.alternanceTag,
        contentColor = AppColors.accent3,
        semanticsLabel = null;

  CardTag.immersion()
      : icon = Icons.business_center_outlined,
        backgroundColor = AppColors.accent3Lighten,
        text = Strings.immersionTag,
        contentColor = AppColors.accent3,
        semanticsLabel = null;

  CardTag.serviceCivique()
      : icon = Icons.business_center_outlined,
        backgroundColor = AppColors.additional5Lighten,
        text = Strings.serviceCiviqueTag,
        contentColor = AppColors.accent3,
        semanticsLabel = null;

  CardTag.entrepriseAccueillante()
      : icon = Icons.volunteer_activism,
        backgroundColor = AppColors.additional1Lighten,
        text = Strings.entrepriseAccueillante,
        contentColor = AppColors.accent2,
        semanticsLabel = null;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.radius_base), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: Dimens.icon_size_base, color: contentColor),
              SizedBox(width: Margins.spacing_xs),
            ],
            Flexible(
              child: Text(
                text,
                semanticsLabel: semanticsLabel,
                style: TextStyles.textXsBold().copyWith(color: contentColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension OffreTypeTagExt on OffreType {
  CardTag toCardTag() {
    return switch (this) {
      OffreType.emploi => CardTag.emploi(),
      OffreType.alternance => CardTag.alternance(),
      OffreType.immersion => CardTag.immersion(),
      OffreType.serviceCivique => CardTag.serviceCivique()
    };
  }
}
