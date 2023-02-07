import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class DateEcheanceInCard extends StatelessWidget {
  final List<FormattedText> formattedTexts;
  final Color color;

  const DateEcheanceInCard({required this.formattedTexts, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SepLine(Margins.spacing_base, Margins.spacing_base),
        Row(
          children: [
            Icon(AppIcons.schedule_rounded, color: color),
            SizedBox(width: Margins.spacing_s),
            _DateTitle(formattedTexts: formattedTexts, color: color),
          ],
        ),
      ],
    );
  }
}

class _DateTitle extends StatelessWidget {
  final List<FormattedText> formattedTexts;
  final Color color;

  const _DateTitle({required this.formattedTexts, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: formattedTexts.map((text) {
            return TextSpan(
              text: text.value,
              style: text.bold ? TextStyles.textBaseBoldWithColor(color) : TextStyles.textSRegularWithColor(color),
            );
          }).toList(),
        ),
      ),
    );
  }
}
