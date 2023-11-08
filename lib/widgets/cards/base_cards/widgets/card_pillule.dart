import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardPillule extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color contentColor;
  final Color backgroundColor;

  const CardPillule({required this.text, required this.contentColor, required this.backgroundColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_l),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacing_s,
          vertical: Margins.spacing_xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: contentColor),
            SizedBox(width: Margins.spacing_xs),
            Text(
              text,
              style: TextStyles.textXsBold().copyWith(color: contentColor),
            )
          ],
        ),
      ),
    );
  }
}
