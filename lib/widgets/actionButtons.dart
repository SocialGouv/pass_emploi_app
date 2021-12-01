import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

TextButton actionButtonWithIcon({
  required String label,
  required String icon,
  required VoidCallback? onPressed,
}) =>
    TextButton.icon(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.nightBlue),
        textStyle: MaterialStateProperty.all(TextStyles.textSmMedium()),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(14)),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.blueGrey;
          } else {
            return AppColors.lightBlue;
          }
        }),
        shape: MaterialStateProperty.all(StadiumBorder()),
      ),
      onPressed: onPressed,
      label: Text(label),
      icon: SvgPicture.asset("assets/$icon"),
    );


TextButton actionButton({
  required String label,
  required VoidCallback? onPressed,
}) =>
    TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(TextStyles.textSmMedium()),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.blueGrey;
          } else {
            return AppColors.nightBlue;
          }
        }),
        shape: MaterialStateProperty.all(StadiumBorder()),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label),
      ),
    );