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

  CardPillule toCardPillule() {
    return switch (this) {
      CardPilluleType.todo => CardPillule.todo(),
      CardPilluleType.doing => CardPillule.doing(),
      CardPilluleType.done => CardPillule.done(),
      CardPilluleType.late => CardPillule.late(),
      CardPilluleType.canceled => CardPillule.canceled(),
    };
  }
}

class CardPillule extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color contentColor;
  final Color backgroundColor;

  const CardPillule({required this.text, required this.contentColor, required this.backgroundColor, this.icon});

  CardPillule.todo()
      : icon = Icons.bolt,
        text = Strings.todoPillule,
        contentColor = AppColors.primaryDarken,
        backgroundColor = AppColors.accent3Lighten;

  CardPillule.doing()
      : icon = Icons.redo,
        text = Strings.doingPillule,
        contentColor = AppColors.accent1,
        backgroundColor = AppColors.accent1Lighten;

  CardPillule.done()
      : icon = Icons.check_circle_outline,
        text = Strings.donePillule,
        contentColor = AppColors.secondary,
        backgroundColor = AppColors.secondaryLighten;

  CardPillule.late()
      : icon = Icons.timer_outlined,
        text = Strings.latePillule,
        contentColor = AppColors.warning,
        backgroundColor = AppColors.warningLighten;

  CardPillule.canceled()
      : icon = Icons.block,
        text = Strings.canceledPillule,
        contentColor = AppColors.disabled,
        backgroundColor = AppColors.grey100;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.radius_l), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Dimens.icon_size_base, color: contentColor),
            SizedBox(width: Margins.spacing_xs),
            Text(text, style: TextStyles.textXsBold().copyWith(color: contentColor))
          ],
        ),
      ),
    );
  }
}
