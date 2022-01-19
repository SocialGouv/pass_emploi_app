import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

class DataCard extends StatelessWidget {
  final String titre;
  final String? sousTitre;
  final String? lieu;
  final List<String> dataTag;
  final VoidCallback onTap;
  final String? id;
  final OffrePage? from;

  const DataCard({
    Key? key,
    required this.titre,
    required this.sousTitre,
    required this.lieu,
    required this.dataTag,
    required this.onTap,
    this.id,
    this.from,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: InkWell(
          onTap: this.onTap,
          splashColor: AppColors.primaryLighten,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTitre(),
                          if (sousTitre != null && sousTitre!.isNotEmpty) _buildSousTitre(),
                        ],
                      ),
                    ),
                    if (id != null && from != null)
                      FavoriHeart(
                        offreId: id!,
                        withBorder: false,
                        from: from!,
                      )
                  ],
                ),
                if (lieu != null && lieu!.isNotEmpty) _buildLieu(),
                if (dataTag.isNotEmpty) _buildDataTag(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitre() {
    return Text(titre, style: TextStyles.textBaseBold);
  }

  Widget _buildSousTitre() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        sousTitre!,
        style: TextStyles.textSBold,
      ),
    );
  }

  Widget _buildLieu() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Drawables.icPlace, color: AppColors.grey800),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              lieu!,
              style: TextStyles.textSRegular(color: AppColors.grey800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTag() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(spacing: 16, runSpacing: 16, children: dataTag.map(_buildTag).toList()),
    );
  }

  Widget _buildTag(String tag) {
    return DataTag(label: tag);
  }
}
