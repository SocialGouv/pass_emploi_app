import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class StatutTag extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final IconData? icon;

  const StatutTag({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
  }) : icon = null;

  const StatutTag.icon({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(360)),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_xs)
          ],
          Text(
            title,
            style: TextStyles.textSRegularWithColor(textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
