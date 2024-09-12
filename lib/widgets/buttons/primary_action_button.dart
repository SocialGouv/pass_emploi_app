import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/focused_border_builder.dart';

class PrimaryActionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color? rippleColor;
  final Color? iconColor;
  final IconData? icon;
  final String label;
  final bool withShadow;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double iconSize;
  final double iconRightPadding;
  final double heightPadding;
  final double widthPadding;
  final bool underlined;
  final Widget? suffix;
  final String? iconLabel;

  PrimaryActionButton({
    super.key,
    Color? backgroundColor,
    this.disabledBackgroundColor = AppColors.disabled,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.primaryDarken,
    this.iconColor = Colors.white,
    this.withShadow = true,
    this.icon,
    this.onPressed,
    required this.label,
    this.fontSize,
    this.iconSize = Dimens.icon_size_m,
    this.iconRightPadding = Margins.spacing_s,
    this.heightPadding = Margins.spacing_base,
    this.widthPadding = Margins.spacing_m,
    this.underlined = false,
    this.suffix,
    this.iconLabel,
  }) : backgroundColor = backgroundColor ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = TextStyles.textPrimaryButton.copyWith(
      decoration: underlined ? TextDecoration.underline : null,
    );
    final usedTextStyle = fontSize != null ? baseTextStyle.copyWith(fontSize: fontSize) : baseTextStyle;
    return FocusedBorderBuilder(builder: (focusNode) {
      return TextButton(
        focusNode: focusNode,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          foregroundColor: MaterialStateProperty.all(textColor),
          textStyle: MaterialStateProperty.all(usedTextStyle),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            return states.contains(MaterialState.disabled) ? disabledBackgroundColor : backgroundColor;
          }),
          elevation: MaterialStateProperty.resolveWith((states) {
            return (states.contains(MaterialState.disabled) || !withShadow) ? 0 : 10;
          }),
          alignment: Alignment.center,
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
          ),
          overlayColor: MaterialStateProperty.all(rippleColor),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthPadding, vertical: heightPadding),
          child: _getRow(),
        ),
      );
    });
  }

  Widget _getRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: iconRightPadding),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyles.textPrimaryButton.copyWith(color: textColor),
        ),
        Semantics(
          label: iconLabel,
        ),
        if (suffix != null)
          Padding(
            padding: EdgeInsets.only(left: Margins.spacing_base),
            child: suffix!,
          ),
      ],
    );
  }
}
