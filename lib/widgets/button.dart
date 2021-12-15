import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

TextButton primaryActionButton({
  required String label,
  required VoidCallback? onPressed,
  Color backgroundColor = AppColors.nightBlue,
  Color disabledBackgroundColor = AppColors.blueGrey,
  Color textColor = Colors.white,
  Color? rippleColor = AppColors.bluePurple,
  String? drawableRes,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (drawableRes != null)
              Padding(padding: const EdgeInsets.only(right: 12), child: SvgPicture.asset(drawableRes)),
            Text(label),
          ],
        ),
      ),
    );
