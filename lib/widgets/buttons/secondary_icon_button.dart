import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';

class SecondaryIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color? borderColor;
  final double iconSize;

  SecondaryIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    Color? iconColor,
    this.borderColor,
    this.iconSize = Dimens.icon_size_m,
  })  : iconColor = iconColor ?? AppColors.primary,
        super(key: key);

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
              child: Icon(icon, size: iconSize, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
