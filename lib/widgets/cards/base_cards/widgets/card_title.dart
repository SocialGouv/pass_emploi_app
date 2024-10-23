import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/accessibility_utils.dart';

class CardTitle extends StatelessWidget {
  const CardTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      // A11y : ensure title is not cut when user has text scale
      maxLines: A11yUtils.withTextScale(context) ? 6 : 3,
      style: TextStyles.textBaseBold.copyWith(fontSize: 16, color: AppColors.contentColor),
    );
  }
}
