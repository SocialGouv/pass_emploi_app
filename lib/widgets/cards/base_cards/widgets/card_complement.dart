import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardComplement extends StatelessWidget {
  const CardComplement({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    const contentColor = AppColors.grey800;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.settings,
          size: 16,
          color: contentColor,
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(
          text,
          style: TextStyles.textSRegular().copyWith(color: contentColor),
        )
      ],
    );
  }
}
