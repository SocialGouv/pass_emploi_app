import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

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
