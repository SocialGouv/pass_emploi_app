import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LienButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LienButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyles.textBaseUnderline.copyWith(color: AppColors.contentColor),
      ),
    );
  }
}
