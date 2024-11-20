import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/pages/evenement_emploi/evenement_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/pages/user_action/update/update_user_action_page.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class PartageMessage extends StatelessWidget {
  final PartageMessageItem item;

  PartageMessage(this.item);

  @override
  Widget build(BuildContext context) {
    return ChatMessageContainer(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ContentMessage(content: item.content, sender: item.sender),
          SizedBox(height: Margins.spacing_base),
          _PartageCard(item: item),
        ],
      ),
      isPj: false,
      isMyMessage: item.sender == Sender.jeune,
      caption: item.caption,
      captionColor: item.captionColor,
    );
  }
}

class _ContentMessage extends StatelessWidget {
  final String content;
  final Sender sender;

  _ContentMessage({required this.content, required this.sender});

  @override
  Widget build(BuildContext context) {
    final style = sender == Sender.jeune
        ? TextStyles.textSRegular(color: Colors.white) //
        : TextStyles.textSRegular();
    return SelectableTextWithClickableLinks(content, linkStyle: style, style: style);
  }
}

class _PartageCard extends StatelessWidget {
  final PartageMessageItem item;

  _PartageCard({required this.item});

  @override
  Widget build(BuildContext context) {
    const border = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)));
    return Semantics(
      button: true,
      child: Material(
        shape: border,
        child: InkWell(
          onTap: () => _onTap(context),
          splashColor: AppColors.primaryLighten,
          customBorder: border,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(item.titrePartage, style: TextStyles.textBaseBold),
                SizedBox(height: Margins.spacing_s),
                _SeeSharedDetails(item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    final item = this.item;
    if (item is OffreMessageItem) {
      _showOffreDetailsPage(context, item);
    } else if (item is EventMessageItem) {
      _showEventDetailsPage(context, item);
    } else if (item is EvenementEmploiMessageItem) {
      _showEvenementEmploiDetailsPage(context, item);
    } else if (item is SessionMiloMessageItem) {
      _showSessionMiloDetailsPage(context, item);
    } else if (item is ActionMessageItem) {
      Navigator.push(context, UpdateUserActionPage.route(UserActionStateSource.noSource, item.idPartage));
    }
  }

  void _showOffreDetailsPage(BuildContext context, OffreMessageItem offreItem) {
    switch (offreItem.type) {
      case OffreType.emploi:
      case OffreType.alternance:
        Navigator.push(
          context,
          OffreEmploiDetailsPage.materialPageRoute(offreItem.idPartage,
              fromAlternance: offreItem.type == OffreType.alternance),
        );
        break;
      case OffreType.immersion:
        Navigator.push(context, ImmersionDetailsPage.materialPageRoute(offreItem.idPartage));
        break;
      case OffreType.civique:
        Navigator.push(context, ServiceCiviqueDetailPage.materialPageRoute(offreItem.idPartage));
        break;
      case OffreType.inconnu:
        break;
    }
  }

  void _showEventDetailsPage(BuildContext context, EventMessageItem item) {
    Navigator.push(
      context,
      RendezvousDetailsPage.materialPageRoute(
        RendezvousStateSource.noSource,
        item.idPartage,
      ),
    );
  }

  void _showEvenementEmploiDetailsPage(BuildContext context, EvenementEmploiMessageItem item) {
    Navigator.push(
      context,
      EvenementEmploiDetailsPage.materialPageRoute(
        item.idPartage,
      ),
    );
  }

  void _showSessionMiloDetailsPage(BuildContext context, SessionMiloMessageItem item) {
    Navigator.push(
      context,
      RendezvousDetailsPage.materialPageRoute(
        RendezvousStateSource.sessionMiloDetails,
        item.idPartage,
      ),
    );
  }
}

class _SeeSharedDetails extends StatelessWidget {
  final PartageMessageItem item;

  _SeeSharedDetails(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(_title(), style: TextStyles.textSRegular()),
        ),
        Icon(AppIcons.chevron_right_rounded, color: AppColors.grey800)
      ],
    );
  }

  String _title() {
    if (item is OffreMessageItem) {
      return Strings.voirOffre;
    } else if (item is EventMessageItem) {
      return Strings.voirEvent;
    }
    return '';
  }
}
