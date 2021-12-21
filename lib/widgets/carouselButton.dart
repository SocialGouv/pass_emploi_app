import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

OutlinedButton carouselButton({
  required String label,
  required VoidCallback? onPressed,
  required bool isActive,
  Color activatedBackgroundColor = AppColors.nightBlue,
  Color disabledBackgroundColor = Colors.transparent,
  Color activatedTextColor = Colors.white,
  Color disabledTextColor = AppColors.nightBlue,
  Color? rippleColor = AppColors.bluePurple
}) =>
    OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(activatedTextColor),
        backgroundColor: isActive ? MaterialStateProperty.all(activatedBackgroundColor) : MaterialStateProperty.all(disabledBackgroundColor),
        shape: MaterialStateProperty.all(StadiumBorder()),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isActive ? Text(label, style: TextStyles.textSmMedium(color: activatedTextColor)) : Text(label, style: TextStyles.textSmMedium()),
          ],
        ),
      ),
    );
