import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final String? drawableRes;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double? fontSize;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.drawableRes,
    this.backgroundColor = Colors.transparent,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = TextStyles.textSecondaryButton;
    final usedTextStyle = fontSize != null ? baseTextStyle.copyWith(fontSize: fontSize) : baseTextStyle;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: backgroundColor,
        side: BorderSide(color: AppColors.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (drawableRes != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SvgPicture.asset(
                  drawableRes!,
                  color: AppColors.primary,
                  width: 10,
                  height: 10,
                ),
              ),
            Flexible(child: Text(label, textAlign: TextAlign.center, style: usedTextStyle)),
          ],
        ),
      ),
    );
  }
}
