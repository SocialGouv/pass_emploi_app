import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateEcheanceInCard extends StatelessWidget {
  final List<FormattedText> formattedTexts;
  final Color color;

  const DateEcheanceInCard({required this.formattedTexts, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
          child: Container(height: 1, color: AppColors.primaryLighten),
        ),
        Row(
          children: [
            SvgPicture.asset(Drawables.icClock, color: color),
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
