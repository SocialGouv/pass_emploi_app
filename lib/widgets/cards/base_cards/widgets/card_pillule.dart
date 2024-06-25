import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

enum CardPilluleType {
  todo,
  doing,
  done,
  late,
  canceled;

  CardPillule toActionCardPillule() {
    return switch (this) {
      CardPilluleType.todo => CardPillule.actionTodo(),
      CardPilluleType.doing => CardPillule.actionTodo(),
      CardPilluleType.done => CardPillule.actionDone(),
      CardPilluleType.late => CardPillule.actionLate(),
      CardPilluleType.canceled => CardPillule.actionDone(),
    };
  }

  CardPillule toDemarcheCardPillule() {
    return switch (this) {
      CardPilluleType.todo => CardPillule.demarcheTodo(),
      CardPilluleType.doing => CardPillule.demarcheDoing(),
      CardPilluleType.done => CardPillule.demarcheDone(),
      CardPilluleType.late => CardPillule.demarcheLate(),
      CardPilluleType.canceled => CardPillule.demarcheCanceled(),
    };
  }
}

class CardPillule extends StatelessWidget {
  final String text;
  final Color contentColor;
  final Color backgroundColor;

  const CardPillule({required this.text, required this.contentColor, required this.backgroundColor});

  CardPillule.actionTodo()
      : text = Strings.doingPillule,
        contentColor = AppColors.accent1,
        backgroundColor = AppColors.accent1Lighten;

  CardPillule.actionDone()
      : text = Strings.donePillule,
        contentColor = AppColors.success,
        backgroundColor = AppColors.successLighten;

  CardPillule.actionLate()
      : text = Strings.latePillule,
        contentColor = AppColors.warning,
        backgroundColor = AppColors.warningLighten;

  CardPillule.demarcheTodo()
      : text = Strings.todoPillule,
        contentColor = AppColors.primaryDarken,
        backgroundColor = AppColors.accent3Lighten;

  CardPillule.demarcheDoing()
      : text = Strings.doingPillule,
        contentColor = AppColors.accent1,
        backgroundColor = AppColors.accent1Lighten;

  CardPillule.demarcheDone()
      : text = Strings.donePillule,
        contentColor = AppColors.success,
        backgroundColor = AppColors.successLighten;

  CardPillule.demarcheLate()
      : text = Strings.latePillule,
        contentColor = AppColors.warning,
        backgroundColor = AppColors.warningLighten;

  CardPillule.demarcheCanceled()
      : text = Strings.canceledPillule,
        contentColor = AppColors.disabled,
        backgroundColor = AppColors.grey100;

  CardPillule.evenementCanceled()
      : text = Strings.rendezvousCardAnnule,
        contentColor = AppColors.disabled,
        backgroundColor = AppColors.grey100;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.radius_l), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
        child: Text(text, style: TextStyles.textXsBold().copyWith(color: contentColor)),
      ),
    );
  }
}
