import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LargeSectionTitle extends StatelessWidget {
  const LargeSectionTitle(this.title, {this.color});
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(title, style: TextStyles.accueilSection.copyWith(color: color ?? AppColors.primary)),
    );
  }
}

class MediumSectionTitle extends StatelessWidget {
  const MediumSectionTitle(this.title, {this.color});
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title,
        style: TextStyles.textMBold.copyWith(color: color ?? AppColors.primary),
      ),
    );
  }
}
