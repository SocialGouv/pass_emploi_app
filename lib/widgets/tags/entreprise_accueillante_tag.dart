import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

class EntrepriseAccueillanteTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTag(
      label: Strings.entrepriseAccueillante,
      drawableRes: Drawables.icRocket,
      contentColor: AppColors.contentColor,
      backgroundColor: AppColors.additional1Lighten,
    );
  }
}
