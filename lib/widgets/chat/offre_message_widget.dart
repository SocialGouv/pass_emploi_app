import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
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
        crossAxisAlignment: item.sender == Sender.conseiller ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
      margin: EdgeInsets.only(
        left: item.sender == Sender.jeune ? 77.0 : 0,
        right: item.sender == Sender.conseiller ? 77.0 : 0,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: item.sender == Sender.jeune ? AppColors.primary : AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ContentMessage(content: item.content, sender: item.sender),
          SizedBox(height: Margins.spacing_base),
          _OfferCard(titreOffre: item.titreOffre, offerId: item.idOffre, type: item.type),
        ],
      ),
    );
  }
}

class _ContentMessage extends StatelessWidget {
  final String content;
  final Sender sender;

  _ContentMessage({required this.content, required this.sender});

  @override
  Widget build(BuildContext context) {
    final style = sender == Sender.jeune ? TextStyles.textSRegular(color: Colors.white) : TextStyles.textSRegular();
    return TextWithClickableLinks(content, linkStyle: style, style: style);
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
    switch (type) {
      case OffreType.emploi:
        Navigator.push(
          context,
          OffreEmploiDetailsPage.materialPageRoute(offerId, fromAlternance: false, showFavori: false),
        );
        break;
      case OffreType.alternance:
        Navigator.push(
          context,
          OffreEmploiDetailsPage.materialPageRoute(offerId, fromAlternance: true, showFavori: false),
        );
        break;
      case OffreType.immersion:
        Navigator.push(context, ImmersionDetailsPage.materialPageRoute(offerId));
        break;
      case OffreType.civique:
        Navigator.push(context, ServiceCiviqueDetailPage.materialPageRoute(offerId));
        break;
      case OffreType.inconnu:
        break;
    }
  }
}
