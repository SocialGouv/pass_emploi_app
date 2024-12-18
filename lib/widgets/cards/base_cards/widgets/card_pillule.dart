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

  CardPillule toActionCardPillule({bool excludeSemantics = false}) {
    return switch (this) {
      CardPilluleType.todo => CardPillule.actionTodo(excludeSemantics),
      CardPilluleType.doing => CardPillule.actionTodo(excludeSemantics),
      CardPilluleType.done => CardPillule.actionDone(excludeSemantics),
      CardPilluleType.late => CardPillule.actionLate(excludeSemantics),
      CardPilluleType.canceled => CardPillule.actionDone(excludeSemantics),
    };
  }

  CardPillule toDemarcheCardPillule({bool excludeSemantics = false}) {
    return switch (this) {
      CardPilluleType.todo => CardPillule.demarcheTodo(excludeSemantics),
      CardPilluleType.doing => CardPillule.demarcheDoing(excludeSemantics),
      CardPilluleType.done => CardPillule.demarcheDone(excludeSemantics),
      CardPilluleType.late => CardPillule.demarcheLate(excludeSemantics),
      CardPilluleType.canceled => CardPillule.demarcheCanceled(excludeSemantics),
    };
  }

  String toSemanticLabel() {
    return switch (this) {
      CardPilluleType.todo => Strings.doingPillule,
      CardPilluleType.doing => Strings.doingPillule,
      CardPilluleType.done => Strings.donePillule,
      CardPilluleType.late => Strings.latePillule,
      CardPilluleType.canceled => Strings.donePillule,
    };
  }
}

class CardPillule extends StatelessWidget {
  final String text;
  final Color contentColor;
  final Color backgroundColor;
  final bool excludeSemantics;

  const CardPillule({
    required this.text,
    required this.contentColor,
    required this.backgroundColor,
    required this.excludeSemantics,
  });

  CardPillule.newNotification([this.excludeSemantics = false])
      : text = Strings.newPillule,
        contentColor = AppColors.warning,
        backgroundColor = AppColors.warningLighten;

  CardPillule.actionTodo([this.excludeSemantics = false])
      : text = Strings.doingPillule,
        contentColor = AppColors.accent1,
        backgroundColor = AppColors.accent1Lighten;

  CardPillule.actionDone([this.excludeSemantics = false])
      : text = Strings.donePillule,
        contentColor = AppColors.success,
        backgroundColor = AppColors.successLighten;

  CardPillule.actionLate([this.excludeSemantics = false])
      : text = Strings.latePillule,
        contentColor = AppColors.warning,
        backgroundColor = AppColors.warningLighten;

  CardPillule.demarcheTodo([this.excludeSemantics = false])
      : text = Strings.todoPillule,
        contentColor = AppColors.primaryDarken,
        backgroundColor = AppColors.accent3Lighten;

  CardPillule.demarcheDoing([this.excludeSemantics = false])
      : text = Strings.doingPillule,
        contentColor = AppColors.accent1,
        backgroundColor = AppColors.accent1Lighten;

  CardPillule.demarcheDone([this.excludeSemantics = false])
      : text = Strings.donePillule,
        contentColor = AppColors.success,
        backgroundColor = AppColors.successLighten;

  CardPillule.demarcheLate([this.excludeSemantics = false])
      : text = Strings.latePillule,
        contentColor = AppColors.warning,
        backgroundColor = AppColors.warningLighten;

  CardPillule.demarcheCanceled([this.excludeSemantics = false])
      : text = Strings.canceledPillule,
        contentColor = AppColors.disabled,
        backgroundColor = AppColors.grey100;

  CardPillule.evenementCanceled([this.excludeSemantics = false])
      : text = Strings.rendezvousCardAnnule,
        contentColor = AppColors.disabled,
        backgroundColor = AppColors.grey100;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.radius_l), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
        child: Semantics(
          excludeSemantics: excludeSemantics,
          child: Text(text, style: TextStyles.textXsBold().copyWith(color: contentColor)),
        ),
      ),
    );
  }
}
