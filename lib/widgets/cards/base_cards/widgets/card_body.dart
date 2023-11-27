import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CardBodyText extends StatelessWidget {
  final String text;

  const CardBodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.textSRegular(color: AppColors.contentColor).copyWith(height: 1.7),
      overflow: TextOverflow.ellipsis,
    );
  }
}
