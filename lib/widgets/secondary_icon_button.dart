import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class SecondaryIconButton extends StatelessWidget {
  final String drawableRes;
  final VoidCallback? onTap;

  const SecondaryIconButton({
    Key? key,
    required this.drawableRes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = 48;
    final double height = 48;
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(side: BorderSide(color: AppColors.primary)),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            child: Center(
              child: SvgPicture.asset(
                drawableRes,
                width: 18,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
