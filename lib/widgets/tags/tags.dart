import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DataTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color contentColor;
  final Color backgroundColor;

  DataTag({
    Key? key,
    required this.label,
    this.icon,
    Color? contentColor,
    this.backgroundColor = AppColors.primaryLighten,
  })  : contentColor = contentColor ?? AppColors.primary,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_s),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(icon, color: contentColor, size: Dimens.icon_size_base),
              ),
            Flexible(child: Text(label, style: TextStyles.textSMedium(color: contentColor))),
          ],
        ),
      ),
    );
  }
}
