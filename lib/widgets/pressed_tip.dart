import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PressedTip extends StatelessWidget {
  final String tip;
  final Color textColor;
  final IconData icon;
  final bool iconLeading;
  final String? iconLabel;

  const PressedTip(this.tip,
      {this.textColor = AppColors.contentColor, this.icon = AppIcons.chevron_right_rounded, this.iconLabel})
      : iconLeading = false;

  PressedTip.externalLink(this.tip, {this.textColor = AppColors.contentColor})
      : icon = AppIcons.open_in_new_rounded,
        iconLabel = null,
        iconLeading = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (iconLeading) ...[
          Icon(icon, color: textColor, size: Dimens.icon_size_base),
          SizedBox(width: Margins.spacing_s),
        ],
        Flexible(
          child: Text(
            tip,
            style: TextStyles.textSBold.copyWith(color: textColor),
            textAlign: TextAlign.start,
          ),
        ),
        Semantics(label: iconLabel),
        if (!iconLeading) ...[
          SizedBox(width: Margins.spacing_s),
          Icon(icon, color: textColor, size: Dimens.icon_size_base)
        ],
      ],
    );
  }
}
