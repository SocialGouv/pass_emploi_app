import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardComplement extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;
  final IconData icon;
  final String? semanticsReplacement;
  final EdgeInsetsGeometry iconPadding;

  const CardComplement({
    required this.text,
    required this.icon,
    this.color = AppColors.grey800,
    this.bold = false,
    this.semanticsReplacement,
    this.iconPadding = EdgeInsets.zero,
  });

  factory CardComplement.place({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.place_outlined,
      );

  factory CardComplement.date({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.event,
      );

  factory CardComplement.dateTime({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.schedule,
      );

  factory CardComplement.time({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.schedule,
      );

  const CardComplement.dateLate({required this.text})
      : icon = AppIcons.event,
        color = AppColors.warning,
        bold = true,
        semanticsReplacement = null,
        iconPadding = EdgeInsets.zero;

  CardComplement.dateDerniereConsultation(DateTime date)
      : text = Strings.offreLastSeen(date),
        icon = AppIcons.visibility_outlined,
        color = AppColors.grey800,
        bold = false,
        semanticsReplacement = Strings.offreLastSeenA11y(date),
        // Required as icon is not centered vertically
        iconPadding = const EdgeInsets.only(top: 2);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsReplacement ?? text,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: iconPadding,
            child: Icon(icon, size: Dimens.icon_size_base, color: color),
          ),
          SizedBox(width: Margins.spacing_xs),
          Flexible(
            fit: FlexFit.loose,
            child: ExcludeSemantics(
              excluding: semanticsReplacement != null,
              child: Text(
                text,
                style: (bold ? TextStyles.textXsBold() : TextStyles.textXsRegular()).copyWith(color: color),
              ),
            ),
          )
        ],
      ),
    );
  }
}
