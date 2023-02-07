import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';

class SecondaryIconButton extends StatelessWidget {
  // TODO: create SecondaryButton.icon(...)
  final String? drawableRes;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color? borderColor;
  final double iconSize;

  const SecondaryIconButton({
    Key? key,
    this.drawableRes,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.primary,
    this.borderColor,
    this.iconSize = Dimens.icon_size_m,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double width = 59;
    const double height = 59;
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(side: BorderSide(color: borderColor ?? iconColor)),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: icon != null
                  ? Icon(icon, size: iconSize, color: iconColor)
                  : SvgPicture.asset(drawableRes!, width: iconSize, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
