import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/string_a11y_extensions.dart';

class CardComplement extends StatelessWidget {
  final String text;
  final Color? color;
  final TextStyle style;
  final IconData icon;
  final String? semanticsReplacement;

  CardComplement({
    required this.text,
    required this.icon,
    this.color = AppColors.contentColor,
    TextStyle? style,
    this.semanticsReplacement,
  }) : style = style ?? TextStyles.textSMedium();

  factory CardComplement.place({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.place_outlined,
      );

  factory CardComplement.date({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.event,
        color: AppColors.contentColor,
        style: TextStyles.textSMedium(),
      );

  factory CardComplement.hour({required String text}) => CardComplement(
        text: text,
        icon: AppIcons.schedule,
        semanticsReplacement: text.toTimeAndDurationForScreenReaders(),
      );

  CardComplement.dateLate({required this.text})
      : icon = AppIcons.event,
        color = AppColors.warning,
        style = TextStyles.textXsBold(),
        semanticsReplacement = null;

  CardComplement.dateDerniereConsultation(DateTime date)
      : text = Strings.offreLastSeen(date),
        icon = AppIcons.visibility_outlined,
        color = AppColors.contentColor,
        style = TextStyles.textXsRegular(),
        semanticsReplacement = Strings.offreLastSeenA11y(date);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsReplacement ?? text,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Dimens.icon_size_base, color: color),
          SizedBox(width: Margins.spacing_xs),
          Flexible(
            fit: FlexFit.loose,
            child: ExcludeSemantics(
              excluding: semanticsReplacement != null,
              child: Text(
                text,
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
