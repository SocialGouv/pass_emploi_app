import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

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
      child: Text(this.sousTitre!, style: TextStyles.textSRegular),
    );
  }

  Widget _buildStatut() {
    String label;
    Color background;
    Color textColor;
    switch (this.statut) {
      case UserActionStatus.NOT_STARTED:
        label = Strings.actionToDo;
        background = AppColors.accent1Lighten;
        textColor = AppColors.accent1;
        break;
      case UserActionStatus.IN_PROGRESS:
        label = Strings.actionInProgress;
        background = AppColors.accent3Lighten;
        textColor = AppColors.accent3;
        break;
      default:
        label = Strings.actionDone;
        background = AppColors.accent2Lighten;
        textColor = AppColors.accent2;
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: background,
            border: Border.all(color: textColor)),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Text(label,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Marianne',
              fontSize: FontSizes.normal,
              fontWeight: FontWeight.w400,
            )),
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
        Text(derniereModification, style: TextStyles.textSRegular),
      ],
    );
  }
}
