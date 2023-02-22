import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/diagoriente_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      clipBehavior: Clip.none,
      margin: const EdgeInsets.all(Margins.spacing_xs),
      decoration: BoxDecoration(
        boxShadow: [Shadows.radius_base],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        // TODO GAD
        //onPressed: () => Navigator.of(context).push(ProfilPage.materialPageRoute()),
        onPressed: () => Navigator.of(context).push(DiagorientePage.materialPageRoute()),
        padding: const EdgeInsets.all(0),
        icon: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [Shadows.radius_base],
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Icon(Icons.person_outline_rounded, size: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
