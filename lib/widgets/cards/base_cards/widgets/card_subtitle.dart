import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardSubtitle extends StatelessWidget {
  const CardSubtitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.textXsBold(color: AppColors.grey800),
    );
  }
}
