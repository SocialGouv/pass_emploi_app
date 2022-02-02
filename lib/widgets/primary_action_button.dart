import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PrimaryActionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color? rippleColor;
  final String? drawableRes;
  final String label;
  final bool withShadow;
  final VoidCallback? onPressed;
  final double iconSize;

  const PrimaryActionButton({
    Key? key,
    this.backgroundColor = AppColors.primary,
    this.disabledBackgroundColor = AppColors.primaryWithAlpha50,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.primaryDarken,
    this.withShadow = true,
    this.drawableRes,
    this.onPressed,
    required this.label,
    this.iconSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double leftPadding = 20;
    if (this.drawableRes != null) {
      leftPadding = 12;
    }
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textColor),
        textStyle: MaterialStateProperty.all(TextStyles.textPrimaryButton),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled) ? disabledBackgroundColor : backgroundColor;
        }),
        elevation: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled) || !withShadow) {
            return 0;
          } else {
            return 10;
          }
        }),
        alignment: Alignment.center,
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200)))),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed) ? rippleColor : null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(padding: EdgeInsets.fromLTRB(leftPadding, 12, 20, 12), child: _getRow()),
    );
  }

  Widget _getRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (drawableRes != null)
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  drawableRes!,
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                ),
              )),
        Text(label),
      ],
    );
  }
}
