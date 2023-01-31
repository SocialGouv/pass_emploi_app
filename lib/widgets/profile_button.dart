import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/profil/profil_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: Margins.spacing_s),
      child: IconButton(
        onPressed: () => Navigator.of(context).push(ProfilPage.materialPageRoute()),
        padding: const EdgeInsets.all(0),
        icon: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [Shadows.boxShadow_wide],
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
