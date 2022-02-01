import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/status_tag.dart';

class EventCard extends StatelessWidget {
  final VoidCallback onTap;
  final String titre;
  final String? sousTitre;
  final UserActionStatus? statut;
  final String? derniereModification;

  const EventCard({
    Key? key,
    required this.onTap,
    required this.titre,
    this.sousTitre,
    this.statut,
    this.derniereModification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        Shadows.boxShadow,
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: this.onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (this.statut != null) _buildStatut(),
                  Text(this.titre, style: TextStyles.textBaseBold),
                  if (this.sousTitre != null && this.sousTitre!.isNotEmpty) _buildSousTitre(),
                  if (this.derniereModification != null) _buildDerniereModification(this.derniereModification!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSousTitre() {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Text(this.sousTitre!, style: TextStyles.textSRegular(color: AppColors.contentColor)),
    );
  }

  Widget _buildStatut() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: StatutTag(
        status: statut!,
      ),
    );
  }

  Widget _buildDerniereModification(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
          child: Container(
            height: 1,
            color: AppColors.primaryLighten,
          ),
        ),
        Text(label, style: TextStyles.textSRegular(color: AppColors.contentColor)),
      ],
    );
  }
}
