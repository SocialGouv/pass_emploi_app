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
  Color? rippleColor = AppColors.bluePurple,
}) =>
    OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(activatedTextColor),
        backgroundColor: isActive
            ? MaterialStateProperty.all(activatedBackgroundColor)
            : MaterialStateProperty.all(disabledBackgroundColor),
        shape: MaterialStateProperty.all(StadiumBorder()),
        side: MaterialStateProperty.all(BorderSide(color: AppColors.nightBlue, width: 1)),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isActive
                ? Text(label, style: TextStyles.textSmMedium(color: activatedTextColor))
                : Text(label, style: TextStyles.textSmMedium()),
          ],
        ),
      ),
    );
