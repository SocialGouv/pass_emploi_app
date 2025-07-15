import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class InformationBandeau extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const InformationBandeau({
    super.key,
    required this.text,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  const InformationBandeau.lighten({
    super.key,
    required this.text,
    required this.icon,
  })  : backgroundColor = AppColors.primaryLighten,
        foregroundColor = AppColors.primaryCej;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.disabled,
        borderRadius: BorderRadius.circular(Margins.spacing_s),
      ),
      child: Padding(
        padding: EdgeInsets.all(Margins.spacing_s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foregroundColor ?? Colors.white, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_s),
            Expanded(child: Text(text, style: TextStyles.textXsRegular(color: foregroundColor ?? Colors.white))),
          ],
        ),
      ),
    );
  }
}
