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
  final IconData? icon;
  final String label;
  final bool withShadow;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double iconSize;
  final double heightPadding;
  final double widthPadding;

  const PrimaryActionButton({
    Key? key,
    this.backgroundColor = AppColors.primary,
    this.disabledBackgroundColor = AppColors.primaryWithAlpha50,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.primaryDarken,
    this.withShadow = true,
    this.drawableRes,
    this.icon,
    this.onPressed,
    required this.label,
    this.fontSize,
    this.iconSize = 12,
    this.heightPadding = 12,
    this.widthPadding = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double leftPadding = drawableRes != null ? 12 : 20;
    final baseTextStyle = TextStyles.textPrimaryButton;
    final usedTextStyle = fontSize != null ? baseTextStyle.copyWith(fontSize: fontSize) : baseTextStyle;
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textColor),
        textStyle: MaterialStateProperty.all(usedTextStyle),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled) ? disabledBackgroundColor : backgroundColor;
        }),
        elevation: MaterialStateProperty.resolveWith((states) {
          return (states.contains(MaterialState.disabled) || !withShadow) ? 0 : 10;
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(leftPadding, heightPadding, widthPadding, heightPadding),
        child: _getRow(),
      ),
    );
  }

  Widget _getRow() {
    return Wrap(
      children: [
        if (drawableRes != null || icon != null)
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: icon != null
                    ? Icon(
                        icon,
                        size: iconSize,
                        color: Colors.white,
                      )
                    : SvgPicture.asset(
                        drawableRes!,
                        height: iconSize,
                        width: iconSize,
                        color: Colors.white,
                      ),
              )),
        Text(
          label,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
