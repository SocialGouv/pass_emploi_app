import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/profil/profil_card.dart';

class StandaloneProfilCard extends StatelessWidget {
  final String text;
  final Function() onTap;

  const StandaloneProfilCard({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_m),
      child: ProfilCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Text(text, style: TextStyles.textBaseRegular)),
                    SizedBox(width: Margins.spacing_s),
                    Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
