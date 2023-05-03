import 'package:flutter/material.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_prochain_rendezvous_item.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';

class AccueilProchainRendezVous extends StatelessWidget {
  final AccueilProchainRendezvousItem item;

  AccueilProchainRendezVous(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilRendezvousSection, style: TextStyles.accueilSection),
        SizedBox(height: Margins.spacing_base),
        item.rendezVousId.rendezvousCard(
          context: context,
          stateSource: RendezvousStateSource.accueilProchainRendezvous,
          trackedEvent: EventType.RDV_DETAIL,
        ),
      ],
    );
  }
}
