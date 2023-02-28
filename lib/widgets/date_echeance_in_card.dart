import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateEcheanceInCard extends StatelessWidget {
  final List<FormattedText> formattedTexts;
  final Color color;

  const DateEcheanceInCard({required this.formattedTexts, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.today_outlined, color: color, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_s),
        Expanded(child: _DateTitle(formattedTexts: formattedTexts, color: color)),
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
    final text = formattedTexts.map((text) => text.value).join();
    return Text(text, style: TextStyles.textSRegularWithColor(color));
  }
}
