import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color? rippleColor;
  final String? drawableRes;
  final VoidCallback? onPressed;

  const PrimaryActionButton({
    Key? key,
    required this.label,
    this.backgroundColor = AppColors.nightBlue,
    this.disabledBackgroundColor = AppColors.blueGrey,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.bluePurple,
    this.drawableRes,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textColor),
        textStyle: MaterialStateProperty.all(TextStyles.textSmMedium()),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled) ? disabledBackgroundColor : backgroundColor;
        }),
        shape: MaterialStateProperty.all(StadiumBorder()),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed) ? rippleColor : null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (drawableRes != null)
              Padding(padding: const EdgeInsets.only(right: 12), child: SvgPicture.asset(drawableRes!)),
            Text(label),
          ],
        ),
      ),
    );
  }
}

TextButton primaryActionButtonWithCustomChild({
  required Row child,
  required VoidCallback? onPressed,
  Color backgroundColor = AppColors.nightBlue,
  Color disabledBackgroundColor = AppColors.blueGrey,
  Color textColor = Colors.white,
  Color? rippleColor = AppColors.bluePurple,
}) =>
    TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textColor),
        textStyle: MaterialStateProperty.all(TextStyles.textSmMedium()),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledBackgroundColor;
          } else {
            return backgroundColor;
          }
        }),
        shape: MaterialStateProperty.all(StadiumBorder()),
        overlayColor: MaterialStateProperty.resolveWith(
              (states) {
            return states.contains(MaterialState.pressed) ? rippleColor : null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: child,
      ),
    );
