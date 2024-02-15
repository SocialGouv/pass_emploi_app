import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/profil/profil_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/focused_border_builder.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, this.isDarkColor = false});

  final bool isDarkColor;

  @override
  Widget build(BuildContext context) {
    return FocusedBorderBuilder(builder: (focusNode) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkColor ? AppColors.primary : AppColors.grey100,
        ),
        child: IconButton(
          tooltip: Strings.profilButtonSemanticsLabel,
          focusNode: focusNode,
          onPressed: () => Navigator.of(context).push(ProfilPage.materialPageRoute()),
          padding: const EdgeInsets.all(0),
          icon: SizedBox.expand(
            child: Icon(
              Icons.person_outline_rounded,
              size: 24,
              color: isDarkColor ? AppColors.grey100 : AppColors.primary,
            ),
          ),
        ),
      );
    });
  }
}
