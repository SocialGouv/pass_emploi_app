import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/profil/profil_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, this.isDarkColor = false});

  final bool isDarkColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: Strings.profilButtonSemanticsLabel,
      child: Container(
        width: 48,
        height: 48,
        clipBehavior: Clip.none,
        margin: const EdgeInsets.all(Margins.spacing_xs),
        decoration: BoxDecoration(
          boxShadow: [Shadows.radius_base],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).push(ProfilPage.materialPageRoute()),
          padding: const EdgeInsets.all(0),
          icon: SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [Shadows.radius_base],
                shape: BoxShape.circle,
                color: isDarkColor ? AppColors.primary : AppColors.grey100,
              ),
              child: Icon(Icons.person_outline_rounded,
                  size: 24, color: isDarkColor ? AppColors.grey100 : AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}
