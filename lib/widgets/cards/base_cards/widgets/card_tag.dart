import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardTag extends StatelessWidget {
  const CardTag({
    this.icon,
    required this.backgroundColor,
    required this.text,
    required this.contentColor,
  });

  CardTag.secondary({
    this.icon,
    required this.text,
  })  : backgroundColor = AppColors.primaryLighten,
        contentColor = AppColors.primary;

  final IconData? icon;
  final Color backgroundColor;
  final String text;
  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacing_s,
          vertical: Margins.spacing_xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: contentColor),
              SizedBox(width: Margins.spacing_xs),
            ],
            Text(
              text,
              style: TextStyles.textXsBold().copyWith(color: contentColor),
            )
          ],
        ),
      ),
    );
  }
}
