import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateEcheance extends StatelessWidget {
  final String formattedDate;
  final bool isLate;
  final Color color;

  const DateEcheance({required this.formattedDate, required this.isLate, required this.color});

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
            _DateTitle(formattedDate: formattedDate, isLate: isLate, color: color),
          ],
        ),
      ],
    );
  }
}

class _DateTitle extends StatelessWidget {
  final String formattedDate;
  final bool isLate;
  final Color color;

  const _DateTitle({required this.formattedDate, required this.isLate, required this.color});

  @override
  Widget build(BuildContext context) {
    if (isLate) {
      return Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: Strings.demarcheLate, style: TextStyles.textBaseBoldWithColor(color)),
              TextSpan(text: formattedDate, style: TextStyles.textSRegularWithColor(color)),
            ],
          ),
        ),
      );
    }
    return Text(formattedDate, style: TextStyles.textSRegularWithColor(color));
  }
}
