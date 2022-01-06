import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ActionButton({Key? key, required this.label, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(TextStyles.textSmMedium()),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled) ? AppColors.blueGrey : AppColors.nightBlue;
        }),
        shape: MaterialStateProperty.all(StadiumBorder()),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label),
      ),
    );
  }
}
