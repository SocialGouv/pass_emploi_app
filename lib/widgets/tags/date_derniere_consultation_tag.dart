import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateDerniereConsultationTag extends StatelessWidget {
  const DateDerniereConsultationTag(this.dateDerniereConsultation);
  final DateTime dateDerniereConsultation;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.grey800;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0), // manually ajust the icon alignment with the text
          child: Icon(AppIcons.visibility_outlined, color: color, size: Dimens.icon_size_base),
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(Strings.offreLastSeen(dateDerniereConsultation), style: TextStyles.textXsMedium(color: color)),
      ],
    );
  }
}
