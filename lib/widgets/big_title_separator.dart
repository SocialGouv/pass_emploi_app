import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class BigTitleSeparator extends StatelessWidget {
  final String label;

  BigTitleSeparator(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 2,
          color: AppColors.contentColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: TextStyles.textMBold,
          ),
        ),
        Container(
          width: 48,
          height: 2,
          color: AppColors.contentColor,
        ),
      ],
    );
  }
}
