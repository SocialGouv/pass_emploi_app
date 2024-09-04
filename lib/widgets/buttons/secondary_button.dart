import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/focused_border_builder.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final String? iconLabel;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.white,
    this.foregroundColor,
    this.fontSize,
    this.iconLabel,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = TextStyles.textSecondaryButton;
    final textColor = foregroundColor ?? AppColors.primary;
    final usedTextStyle = fontSize != null ? baseTextStyle.copyWith(fontSize: fontSize) : baseTextStyle;
    return FocusedBorderBuilder(builder: (focusNode) {
      return OutlinedButton(
        focusNode: focusNode,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: backgroundColor,
          side: BorderSide(color: textColor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      icon,
                      color: textColor,
                      size: Dimens.icon_size_m,
                    )),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: usedTextStyle.copyWith(color: textColor),
                ),
              ),
              Semantics(label: iconLabel),
            ],
          ),
        ),
      );
    });
  }
}
