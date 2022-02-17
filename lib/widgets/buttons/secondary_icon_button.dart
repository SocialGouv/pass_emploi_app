import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class SecondaryIconButton extends StatelessWidget {
  final String drawableRes;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color? borderColor;
  final double iconSize;

  const SecondaryIconButton({
    Key? key,
    required this.drawableRes,
    required this.onTap,
    this.iconColor = AppColors.primary,
    this.borderColor,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = 59;
    final double height = 59;
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(side: BorderSide(color: borderColor ?? iconColor)),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            child: Center(
              child: SvgPicture.asset(drawableRes, width: iconSize, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
