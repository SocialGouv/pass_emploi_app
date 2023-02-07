import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

class EntrepriseAccueillanteTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTag(
      label: Strings.entrepriseAccueillante,
      icon: AppIcons.rocket_launch_rounded,
      contentColor: AppColors.contentColor,
      backgroundColor: AppColors.additional1Lighten,
    );
  }
}
