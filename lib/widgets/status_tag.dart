import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class StatutTag extends StatelessWidget {
  final UserActionStatus status;

  const StatutTag({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label;
    Color background;
    Color textColor;
    switch (this.status) {
      case UserActionStatus.NOT_STARTED:
        label = Strings.actionToDo;
        background = AppColors.accent1Lighten;
        textColor = AppColors.accent1;
        break;
      case UserActionStatus.IN_PROGRESS:
        label = Strings.actionInProgress;
        background = AppColors.accent3Lighten;
        textColor = AppColors.accent3;
        break;
      default:
        label = Strings.actionDone;
        background = AppColors.accent2Lighten;
        textColor = AppColors.accent2;
        break;
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)), color: background, border: Border.all(color: textColor)),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        label,
        style: TextStyles.textSRegularWithColor(textColor),
      ),
    );
  }
}
