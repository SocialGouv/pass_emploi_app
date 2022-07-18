import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class OffreMessageWidget extends StatelessWidget {
  final OffreMessageItem item;

  OffreMessageWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: item is ConseillerMessageItem ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          _MessageBubble(item: item),
          SizedBox(height: Margins.spacing_xs),
          Text(item.caption, style: TextStyles.textXsRegular())
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final OffreMessageItem item;

  _MessageBubble({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 77.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ContentMessage(content: item.content),
          SizedBox(height: Margins.spacing_base),
          _OfferCard(titreOffre: item.titreOffre, offerId: item.idOffre, type: item.type),
        ],
      ),
    );
  }
}

class _ContentMessage extends StatelessWidget {
  final String content;

  _ContentMessage({required this.content});

  @override
  Widget build(BuildContext context) {
    return TextWithClickableLinks(
      content,
      linkStyle: TextStyles.textSRegular(color: Colors.white),
      style: TextStyles.textSRegular(color: Colors.white),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String titreOffre;
  final String offerId;
  final OffreType type;

  _OfferCard({required this.titreOffre, required this.offerId, required this.type});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: InkWell(
          onTap: () => _showOffreEmploiDetailsPage(context),
          splashColor: AppColors.primaryLighten,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(titreOffre, style: TextStyles.textBaseBold),
                SizedBox(height: Margins.spacing_s),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(Strings.voirOffre, style: TextStyles.textSRegular()),
                    ),
                    SvgPicture.asset(Drawables.icChevronRight, color: AppColors.grey800)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOffreEmploiDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      OffreEmploiDetailsPage.materialPageRoute(
        offerId,
        fromAlternance: type == OffreType.alternance,
        showFavori: false,
      ),
    );
  }
}
