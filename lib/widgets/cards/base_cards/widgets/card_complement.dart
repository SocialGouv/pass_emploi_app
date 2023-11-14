import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardComplement extends StatelessWidget {
  final String text;
  final IconData icon;

  const CardComplement({required this.text, required this.icon});

  const CardComplement.place({required this.text}) : icon = AppIcons.location_on_rounded;

  @override
  Widget build(BuildContext context) {
    const contentColor = AppColors.grey800;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: Dimens.icon_size_base, color: contentColor),
        SizedBox(width: Margins.spacing_xs),
        Text(text, style: TextStyles.textSRegular().copyWith(color: contentColor))
      ],
    );
  }
}
