import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CalendarCard extends StatelessWidget {
  final String date;
  final String titre;
  final String? sousTitre;
  final String texteLien;
  final VoidCallback onTap;

  const CalendarCard({
    Key? key,
    required this.date,
    required this.titre,
    this.sousTitre,
    required this.texteLien,
    required this.onTap,
  }) : super(key: key);

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
                _buildDate(),
                Text(this.titre, style: TextStyles.textBaseBold),
                if (this.sousTitre != null && this.sousTitre!.isNotEmpty) _buildSousTitre(),
                _buildLink(),
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
      child: Text(this.sousTitre!, style: TextStyles.textSRegular(color: AppColors.grey800)),
    );
  }

  Widget _buildDate() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10),
      child: Row(
        children: [
          SvgPicture.asset(Drawables.icClock, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            this.date,
            style: TextStyles.textSRegularWithColor(
              AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          Text(this.texteLien,
              style: TextStyles.textSRegularWithColor(
                AppColors.contentColor,
              )),
          SizedBox(width: 8),
          SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
        ],
      ),
    );
  }
}
