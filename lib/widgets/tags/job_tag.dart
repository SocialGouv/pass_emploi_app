import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
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
