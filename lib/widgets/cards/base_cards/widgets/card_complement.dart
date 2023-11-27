import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardComplement extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;
  final IconData icon;

  const CardComplement({required this.text, required this.icon, this.color = AppColors.grey800, this.bold = false});

  const CardComplement.place({required this.text})
      : icon = AppIcons.place_outlined,
        bold = false,
        color = AppColors.grey800;

  const CardComplement.date({required this.text})
      : icon = AppIcons.event,
        bold = false,
        color = AppColors.grey800;

  const CardComplement.dateLate({required this.text})
      : icon = AppIcons.event,
        color = AppColors.warning,
        bold = true;

  const CardComplement.dateTime({required this.text})
      : icon = AppIcons.schedule,
        bold = false,
        color = AppColors.grey800;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: Dimens.icon_size_base, color: color),
        SizedBox(width: Margins.spacing_xs),
        Flexible(
            fit: FlexFit.loose,
            child: Text(
              text,
              style: (bold ? TextStyles.textSBold : TextStyles.textSRegular()).copyWith(color: color),
            ))
      ],
    );
  }
}
