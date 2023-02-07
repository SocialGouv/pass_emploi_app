import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DataTag extends StatelessWidget {
  final String label;
  final String? drawableRes;
  final IconData? icon;
  final Color contentColor;
  final Color backgroundColor;

  const DataTag({
    Key? key,
    required this.label,
    this.drawableRes,
    this.icon,
    this.contentColor = AppColors.primary,
    this.backgroundColor = AppColors.primaryLighten,
  }) : super(key: key);

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
            if (drawableRes != null || icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: icon != null
                    ? Icon(icon, color: contentColor)
                    : SvgPicture.asset(drawableRes!, color: contentColor),
              ),
            Flexible(child: Text(label, style: TextStyles.textSMedium(color: contentColor))),
          ],
        ),
      ),
    );
  }
}
