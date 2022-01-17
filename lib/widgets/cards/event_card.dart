import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(0, 6), // changes position of shadow
        )
      ]),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: this.onTap,
          splashColor: AppColors.primaryLighten,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (this.statut != null) _buildStatut(),
                Text(this.titre, style: TextStyles.textBaseBold),
                if (this.sousTitre != null && this.sousTitre!.isNotEmpty) _buildSousTitre(),
                if (this.derniereModification != null) _buildDerniereModification(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSousTitre() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(this.sousTitre!, style: TextStyles.textSRegular(color: AppColors.neutralColor)),
    );
  }

  Widget _buildStatut() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: StatutTag(
        status: statut!,
      ),
    );
  }

  Widget _buildDerniereModification() {
    final String derniereModification = Strings.lastModificationPrefix + this.derniereModification!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 1,
            color: AppColors.shadowColor,
          ),
        ),
        Text(derniereModification, style: TextStyles.textSRegular(color: AppColors.neutralColor)),
      ],
    );
  }
}
